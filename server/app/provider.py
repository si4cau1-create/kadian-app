"""OpenAI 兼容上游：流式与非流式两种调用。

代理不缓存内容、不落库；失败重试一次备用模型（如果配置了）。
"""

from __future__ import annotations

import json
from typing import AsyncIterator, Any

import httpx

from .config import settings


class UpstreamError(RuntimeError):
    pass


class LlmProvider:
    def __init__(self) -> None:
        self._client: httpx.AsyncClient | None = None

    async def client(self) -> httpx.AsyncClient:
        if self._client is None or self._client.is_closed:
            self._client = httpx.AsyncClient(
                base_url=settings.llm_base_url.rstrip("/"),
                headers={
                    "Authorization": f"Bearer {settings.llm_api_key}",
                    "Content-Type": "application/json",
                },
                timeout=httpx.Timeout(
                    settings.llm_timeout_seconds,
                    connect=15.0,
                ),
            )
        return self._client

    async def aclose(self) -> None:
        if self._client is not None and not self._client.is_closed:
            await self._client.aclose()

    def _payload(
        self,
        messages: list[dict[str, str]],
        *,
        model: str | None = None,
        stream: bool,
        temperature: float,
        json_mode: bool,
    ) -> dict[str, Any]:
        body: dict[str, Any] = {
            "model": model or settings.llm_model,
            "messages": messages,
            "stream": stream,
            "temperature": temperature,
        }
        if json_mode:
            body["response_format"] = {"type": "json_object"}
        return body

    async def stream(
        self,
        messages: list[dict[str, str]],
        *,
        temperature: float = 0.4,
    ) -> AsyncIterator[str]:
        if not settings.llm_configured:
            raise UpstreamError("上游模型未配置（LLM_BASE_URL / LLM_API_KEY / LLM_MODEL）")

        client = await self.client()
        try:
            async with client.stream(
                "POST",
                "/chat/completions",
                json=self._payload(
                    messages,
                    stream=True,
                    temperature=temperature,
                    json_mode=False,
                ),
            ) as response:
                if response.status_code >= 400:
                    detail = await response.aread()
                    raise UpstreamError(
                        f"上游 {response.status_code}: {detail[:300]!r}"
                    )
                async for line in response.aiter_lines():
                    if not line or not line.startswith("data:"):
                        continue
                    payload = line[5:].strip()
                    if payload == "[DONE]":
                        break
                    try:
                        data = json.loads(payload)
                    except json.JSONDecodeError:
                        continue
                    choices = data.get("choices") or []
                    if not choices:
                        continue
                    delta = choices[0].get("delta") or {}
                    content = delta.get("content")
                    if content:
                        yield content
        except httpx.HTTPError as exc:  # pragma: no cover - 网络依赖
            raise UpstreamError(f"上游连接失败: {exc}") from exc

    async def complete_json(
        self,
        messages: list[dict[str, str]],
        *,
        temperature: float = 0.2,
    ) -> str:
        if not settings.llm_configured:
            raise UpstreamError("上游模型未配置")

        client = await self.client()
        models = [settings.llm_model]
        if settings.llm_fallback_model:
            models.append(settings.llm_fallback_model)

        last_error: Exception | None = None
        for model in models:
            try:
                response = await client.post(
                    "/chat/completions",
                    json=self._payload(
                        messages,
                        model=model,
                        stream=False,
                        temperature=temperature,
                        json_mode=True,
                    ),
                )
                if response.status_code >= 400:
                    raise UpstreamError(
                        f"上游 {response.status_code}: {response.text[:300]}"
                    )
                data = response.json()
                choices = data.get("choices") or []
                if not choices:
                    raise UpstreamError("上游返回空 choices")
                content = (choices[0].get("message") or {}).get("content") or ""
                if not content.strip():
                    raise UpstreamError("上游返回空内容")
                return content
            except (httpx.HTTPError, UpstreamError) as exc:
                last_error = exc
                continue
        raise UpstreamError(str(last_error) if last_error else "上游调用失败")


provider = LlmProvider()
