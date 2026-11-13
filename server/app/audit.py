"""审计：只记录「谁、什么时候、问了哪题、几次提示、是否被过滤」，不记录作答原文。

隐私底线：selected_text 默认不落库，只存长度与哈希前缀；需要排查时打开
LOG_ANSWER_TEXT（不建议在生产开启）。
"""

from __future__ import annotations

import hashlib
import os
import sqlite3
import threading
import time
from typing import Any

from .config import settings

_SCHEMA = """
CREATE TABLE IF NOT EXISTS audit (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts INTEGER NOT NULL,
  token_fp TEXT NOT NULL,
  endpoint TEXT NOT NULL,
  subject TEXT,
  item_id TEXT,
  hint_level INTEGER,
  filtered INTEGER DEFAULT 0,
  scope_warnings INTEGER DEFAULT 0,
  status INTEGER DEFAULT 200,
  latency_ms INTEGER DEFAULT 0,
  text_len INTEGER DEFAULT 0,
  text_hash TEXT,
  text_raw TEXT
);
CREATE INDEX IF NOT EXISTS idx_audit_ts ON audit(ts);
CREATE INDEX IF NOT EXISTS idx_audit_fp ON audit(token_fp);
"""


class AuditLog:
    def __init__(self, path: str) -> None:
        self.path = path
        self._lock = threading.Lock()
        self._ready = False

    def _connect(self) -> sqlite3.Connection:
        os.makedirs(os.path.dirname(os.path.abspath(self.path)), exist_ok=True)
        conn = sqlite3.connect(self.path, check_same_thread=False)
        conn.execute("PRAGMA journal_mode=WAL")
        return conn

    def init(self) -> None:
        with self._lock:
            if self._ready:
                return
            conn = self._connect()
            conn.executescript(_SCHEMA)
            conn.commit()
            conn.close()
            self._ready = True

    def record(
        self,
        *,
        token_fp: str,
        endpoint: str,
        subject: str = "",
        item_id: str = "",
        hint_level: int = 0,
        filtered: bool = False,
        scope_warnings: int = 0,
        status: int = 200,
        latency_ms: int = 0,
        text: str = "",
    ) -> None:
        digest = hashlib.sha256(text.encode()).hexdigest()[:16] if text else ""
        with self._lock:
            try:
                conn = self._connect()
                conn.execute(
                    "INSERT INTO audit (ts, token_fp, endpoint, subject, item_id,"
                    " hint_level, filtered, scope_warnings, status, latency_ms,"
                    " text_len, text_hash, text_raw)"
                    " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
                    (
                        int(time.time()),
                        token_fp,
                        endpoint,
                        subject,
                        item_id,
                        hint_level,
                        int(filtered),
                        scope_warnings,
                        status,
                        latency_ms,
                        len(text),
                        digest,
                        text if settings.log_answer_text else None,
                    ),
                )
                conn.commit()
                conn.close()
            except sqlite3.Error:
                # 审计失败不能拖垮请求；生产用日志系统兜底
                pass

    def recent(self, limit: int = 100) -> list[dict[str, Any]]:
        with self._lock:
            conn = self._connect()
            conn.row_factory = sqlite3.Row
            rows = conn.execute(
                "SELECT ts, token_fp, endpoint, subject, item_id, hint_level,"
                " filtered, scope_warnings, status, latency_ms, text_len"
                " FROM audit ORDER BY id DESC LIMIT ?",
                (limit,),
            ).fetchall()
            conn.close()
            return [dict(row) for row in rows]


audit = AuditLog(settings.audit_db_path)
