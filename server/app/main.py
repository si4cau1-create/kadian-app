"""卡点 LLM 代理服务。

职责边界（照规格逐条落实）：
- 鉴权：设备令牌（HMAC），无会话表
- 限流：每令牌每小时
- 审计：只记元数据，不记作答原文
- 隐藏 Provider Key：Key 只在服务端环境变量里
- 角色路由：诊断官/出题官/攻略官/归因官/成就官各一套 system prompt
- 答案泄露过滤：一二级提示强制过滤，与客户端双重执行
- 超纲检查：低等级学习者不给高级术语（提示词约束 + 审计标记）
- 不持久化等级数据：请求里的 learner_level_summary 用完即弃
"""

from __future__ import annotations

import json
import time
from contextlib import asynccontextmanager
from typing import Any, AsyncIterator

from fastapi import Depends, FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, ConfigDict

from . import prompts
from .audit import audit
from .auth import Principal, issue_token, require_token
from .config import settings
from .guards import (
    ensure_json_object,
    filter_answer_leak,
    scope_violations,
)
from .limits import SlidingWindowLimiter
from .provider import UpstreamError, provider

VERSION = "1.0.0"

hint_limiter = SlidingWindowLimiter(settings.rate_limit_per_hour)
generate_limiter = SlidingWindowLimiter(settings.rate_limit_generate_per_hour)


@asynccontextmanager
async def lifespan(_: FastAPI):
    audit.init()
    yield
    await provider.aclose()


app = FastAPI(title="Kadian LLM Proxy", version=VERSION, lifespan=lifespan)

# 桌面端（Windows）在开发期可能带 Origin；移动端不带。生产可收紧。
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)


class Body(BaseModel):
    model_config = ConfigDict(extra="allow")


class AnonymousAuth(BaseModel):
    model_config = ConfigDict(extra="allow")
    device_id: str


def _clamp_level(raw: Any) -> int:
    try:
        level = int(raw)
    except (TypeError, ValueError):
        level = 1
    return max(settings.min_hint_level, min(settings.max_hint_level, level))


def _sse(event: dict[str, Any]) -> str:
    return f"data: {json.dumps(event, ensure_ascii=False)}\n\n"


def _error(message: str, code: str = "upstream_error", status: int = 502):
    return HTTPException(status_code=status, detail={"code": code, "message": message})


@app.get("/healthz")
async def healthz() -> dict[str, Any]:
    return {
        "ok": True,
        "version": VERSION,
        "llm_configured": settings.llm_configured,
        "rate_limit_per_hour": settings.rate_limit_per_hour,
        "time": int(time.time()),
    }


@app.post("/v1/auth/anonymous")
async def auth_anonymous(body: AnonymousAuth) -> dict[str, Any]:
    if not settings.allow_anonymous:
        raise HTTPException(status_code=403, detail="未开放匿名设备令牌")
    try:
        token = issue_token(body.device_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    return {
        "token": token,
        "token_type": "bearer",
        "expires_in": settings.token_ttl_days * 86400,
    }


@app.post("/v1/hints")
async def hints(body: Body, principal: Principal = Depends(require_token)):
    allowed, remaining, retry_after = await hint_limiter.acquire(
        f"hints:{principal.device_id}"
    )
    if not allowed:
        raise HTTPException(
            status_code=429,
            detail={"code": "rate_limited", "message": "请求太频繁"},
            headers={"Retry-After": str(retry_after)},
        )

    payload = body.model_dump()
    level = _clamp_level(payload.get("hint_level"))
    request_id = str(payload.get("request_id") or "")
    messages = prompts.hint_messages({**payload, "hint_level": level})
    keywords = [str(k) for k in (payload.get("answer_keywords") or [])]
    answer_label = str(payload.get("answer_label") or "")
    subject = str(payload.get("subject") or "ja")
    learner_level = 0
    summary = payload.get("learner_level_summary") or {}
    if isinstance(summary, dict) and isinstance(summary.get("overall"), dict):
        learner_level = int(summary["overall"].get("level") or 0)

    async def event_stream() -> AsyncIterator[str]:
        started = time.monotonic()
        filtered = False
        warnings = 0
        full_text = ""
        try:
            yield _sse(
                {
                    "type": "meta",
                    "request_id": request_id,
                    "level": level,
                    "remaining": remaining,
                }
            )

            if level <= 2:
                # 一二级必须先攒齐再过滤，避免「边流边漏」
                chunks: list[str] = []
                async for chunk in provider.stream(messages):
                    chunks.append(chunk)
                raw = "".join(chunks)
                result = filter_answer_leak(
                    raw,
                    level=level,
                    keywords=keywords,
                    answer_label=answer_label,
                )
                filtered = result.filtered
                warnings = len(scope_violations(raw, subject=subject, learner_level=learner_level))
                full_text = result.text
                step = 48
                for i in range(0, len(full_text), step):
                    yield _sse({"type": "delta", "delta": full_text[i : i + step]})
                yield _sse(
                    {
                        "type": "done",
                        "done": True,
                        "request_id": request_id,
                        "level": level,
                        "filtered": filtered,
                    }
                )
            else:
                async for chunk in provider.stream(messages):
                    full_text += chunk
                    yield _sse({"type": "delta", "delta": chunk})
                warnings = len(scope_violations(full_text, subject=subject, learner_level=learner_level))
                yield _sse(
                    {
                        "type": "done",
                        "done": True,
                        "request_id": request_id,
                        "level": level,
                        "filtered": False,
                    }
                )
        except UpstreamError as exc:
            yield _sse(
                {
                    "type": "error",
                    "error": str(exc),
                    "request_id": request_id,
                    "done": True,
                }
            )
        finally:
            audit.record(
                token_fp=principal.token_fingerprint,
                endpoint="/v1/hints",
                subject=subject,
                item_id=str(payload.get("item_id") or ""),
                hint_level=level,
                filtered=filtered,
                scope_warnings=warnings,
                latency_ms=int((time.monotonic() - started) * 1000),
                text=full_text,
            )

    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",
            "Connection": "keep-alive",
        },
    )


@app.post("/v1/diagnose/next")
async def diagnose_next(body: Body, principal: Principal = Depends(require_token)):
    payload = body.model_dump()
    candidates = payload.get("candidate_items") or []
    if not candidates:
        # 客户端本地选题已足够；没有候选就明确返回空，不编造题目 id
        return {
            "item_ids": [],
            "rationale": "未提供候选题目：选题由客户端本地 IRT 信息量算法完成。",
        }
    try:
        raw = await provider.complete_json(prompts.diagnose_messages(payload))
        data = ensure_json_object(raw, ["item_ids"])
    except (UpstreamError, ValueError) as exc:
        raise _error(str(exc)) from exc

    valid = {str(c.get("id")) for c in candidates if isinstance(c, dict)}
    picked = [str(i) for i in data.get("item_ids", []) if str(i) in valid]
    audit.record(
        token_fp=principal.token_fingerprint,
        endpoint="/v1/diagnose/next",
        subject=str(payload.get("subject") or ""),
        status=200,
        text=raw,
    )
    return {"item_ids": picked, "rationale": str(data.get("rationale", ""))}


@app.post("/v1/items/generate")
async def items_generate(
    body: Body,
    x_internal_key: str | None = Header(default=None),
    principal: Principal = Depends(require_token),
):
    if x_internal_key != settings.internal_key:
        raise HTTPException(status_code=403, detail="内部接口：需要 X-Internal-Key")
    allowed, _, retry_after = await generate_limiter.acquire(
        f"generate:{principal.device_id}"
    )
    if not allowed:
        raise HTTPException(
            status_code=429,
            detail={"code": "rate_limited", "message": "出题请求太频繁"},
            headers={"Retry-After": str(retry_after)},
        )
    payload = body.model_dump()
    try:
        raw = await provider.complete_json(prompts.item_generate_messages(payload))
        data = ensure_json_object(raw, ["items"])
    except (UpstreamError, ValueError) as exc:
        raise _error(str(exc)) from exc
    items = data.get("items")
    if not isinstance(items, list):
        raise _error("items 必须是数组")
    audit.record(
        token_fp=principal.token_fingerprint,
        endpoint="/v1/items/generate",
        status=200,
        text=raw,
    )
    return {"items": items}


@app.post("/v1/attribute")
async def attribute(body: Body, principal: Principal = Depends(require_token)):
    payload = body.model_dump()
    try:
        raw = await provider.complete_json(prompts.attribute_messages(payload))
        data = ensure_json_object(raw, ["tags", "summary"])
    except (UpstreamError, ValueError) as exc:
        raise _error(str(exc)) from exc
    audit.record(
        token_fp=principal.token_fingerprint,
        endpoint="/v1/attribute",
        subject=str(payload.get("subject") or ""),
        text=raw,
    )
    return {
        "tags": [str(t) for t in data.get("tags", [])][:5],
        "summary": str(data.get("summary", "")),
        "confidence": float(data.get("confidence") or 0),
    }


@app.post("/v1/achievements/explain")
async def achievements_explain(body: Body, principal: Principal = Depends(require_token)):
    payload = body.model_dump()
    try:
        raw = await provider.complete_json(prompts.achievement_messages(payload))
        data = ensure_json_object(raw, ["title", "explanation"])
    except (UpstreamError, ValueError) as exc:
        raise _error(str(exc)) from exc
    audit.record(
        token_fp=principal.token_fingerprint,
        endpoint="/v1/achievements/explain",
        text=raw,
    )
    return {
        "title": str(data.get("title", "")),
        "explanation": str(data.get("explanation", "")),
    }


@app.get("/v1/admin/audit")
async def admin_audit(
    limit: int = 100,
    x_internal_key: str | None = Header(default=None),
):
    if x_internal_key != settings.internal_key:
        raise HTTPException(status_code=403, detail="需要 X-Internal-Key")
    return {"items": audit.recent(limit=max(1, min(limit, 500)))}
