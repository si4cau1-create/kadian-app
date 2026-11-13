"""设备令牌：HMAC 签名，无状态，不存会话表。

令牌里只有 device_id 和过期时间——不绑定账号，不装任何等级数据。
"""

from __future__ import annotations

import base64
import hashlib
import hmac
import json
import time
from dataclasses import dataclass

from fastapi import Header, HTTPException

from .config import settings


class TokenError(ValueError):
    pass


def _b64encode(raw: bytes) -> str:
    return base64.urlsafe_b64encode(raw).decode().rstrip("=")


def _b64decode(text: str) -> bytes:
    padding = "=" * (-len(text) % 4)
    return base64.urlsafe_b64decode(text + padding)


def _sign(payload: bytes, secret: str) -> str:
    digest = hmac.new(secret.encode(), payload, hashlib.sha256).digest()
    return _b64encode(digest)


def issue_token(device_id: str, *, ttl_days: int | None = None) -> str:
    if not device_id or len(device_id) > 128:
        raise TokenError("device_id 非法")
    ttl = (ttl_days if ttl_days is not None else settings.token_ttl_days) * 86400
    payload = {
        "sub": device_id,
        "iat": int(time.time()),
        "exp": int(time.time()) + ttl,
    }
    raw = json.dumps(payload, separators=(",", ":")).encode()
    return f"{_b64encode(raw)}.{_sign(raw, settings.token_secret)}"


def verify_token(token: str) -> dict:
    try:
        body, signature = token.split(".", 1)
    except ValueError as exc:
        raise TokenError("令牌格式错误") from exc
    raw = _b64decode(body)
    expected = _sign(raw, settings.token_secret)
    if not hmac.compare_digest(expected, signature):
        raise TokenError("令牌签名不匹配")
    try:
        payload = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise TokenError("令牌载荷损坏") from exc
    if int(payload.get("exp", 0)) < int(time.time()):
        raise TokenError("令牌已过期")
    return payload


def fingerprint(token: str) -> str:
    """审计里只存指纹，不存令牌本身。"""
    return hashlib.sha256(token.encode()).hexdigest()[:12]


@dataclass
class Principal:
    device_id: str
    token_fingerprint: str


async def require_token(
    authorization: str | None = Header(default=None),
) -> Principal:
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=401, detail="缺少设备令牌")
    token = authorization.split(" ", 1)[1].strip()
    try:
        payload = verify_token(token)
    except TokenError as exc:
        raise HTTPException(status_code=401, detail=str(exc)) from exc
    return Principal(device_id=str(payload["sub"]), token_fingerprint=fingerprint(token))
