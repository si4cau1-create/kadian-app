"""LLM 代理配置：全部来自环境变量，不落文件、不进镜像。

设计原则：代理只做鉴权、限流、审计、转发与合规过滤。
它不保存任何等级数据，也不参与等级计算——等级全在客户端本地算。
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field


def _env(name: str, default: str = "") -> str:
    return os.environ.get(name, default).strip()


def _int(name: str, default: int) -> int:
    try:
        return int(os.environ.get(name, str(default)))
    except ValueError:
        return default


def _bool(name: str, default: bool) -> bool:
    raw = os.environ.get(name)
    if raw is None:
        return default
    return raw.strip().lower() in {"1", "true", "yes", "on"}


@dataclass
class Settings:
    # 上游模型（OpenAI 兼容）
    llm_base_url: str = field(default_factory=lambda: _env("LLM_BASE_URL"))
    llm_api_key: str = field(default_factory=lambda: _env("LLM_API_KEY"))
    llm_model: str = field(default_factory=lambda: _env("LLM_MODEL", "deepseek-chat"))
    llm_fallback_model: str = field(default_factory=lambda: _env("LLM_FALLBACK_MODEL"))
    llm_timeout_seconds: int = field(default_factory=lambda: _int("LLM_TIMEOUT_SECONDS", 90))

    # 鉴权
    token_secret: str = field(default_factory=lambda: _env("TOKEN_SECRET", "dev-only-change-me"))
    token_ttl_days: int = field(default_factory=lambda: _int("TOKEN_TTL_DAYS", 30))
    allow_anonymous: bool = field(default_factory=lambda: _bool("ALLOW_ANONYMOUS", True))
    internal_key: str = field(default_factory=lambda: _env("INTERNAL_KEY", "dev-internal-key"))

    # 限流（每令牌每小时）
    rate_limit_per_hour: int = field(default_factory=lambda: _int("RATE_LIMIT_PER_HOUR", 60))
    rate_limit_generate_per_hour: int = field(
        default_factory=lambda: _int("RATE_LIMIT_GENERATE_PER_HOUR", 20)
    )

    # 审计
    audit_db_path: str = field(default_factory=lambda: _env("AUDIT_DB_PATH", "./data/audit.sqlite3"))
    log_answer_text: bool = field(default_factory=lambda: _bool("LOG_ANSWER_TEXT", False))

    # 合规
    max_selected_chars: int = field(default_factory=lambda: _int("MAX_SELECTED_CHARS", 600))
    min_hint_level: int = 1
    max_hint_level: int = 4

    @property
    def llm_configured(self) -> bool:
        return bool(self.llm_base_url and self.llm_api_key and self.llm_model)


settings = Settings()
