"""滑动窗口限流：令牌 + 端点维度。

单实例内存实现，够内测用；多实例部署时换 Redis（接口保持不变）。
"""

from __future__ import annotations

import asyncio
import time
from collections import defaultdict, deque


class SlidingWindowLimiter:
    def __init__(self, limit: int, window_seconds: int = 3600) -> None:
        self.limit = limit
        self.window = window_seconds
        self._hits: dict[str, deque[float]] = defaultdict(deque)
        self._lock = asyncio.Lock()

    async def acquire(self, key: str) -> tuple[bool, int, int]:
        """返回 (是否放行, 剩余次数, 建议等待秒数)。"""
        async with self._lock:
            now = time.monotonic()
            bucket = self._hits[key]
            while bucket and now - bucket[0] > self.window:
                bucket.popleft()
            if len(bucket) >= self.limit:
                wait = int(self.window - (now - bucket[0])) + 1
                return False, 0, max(wait, 1)
            bucket.append(now)
            return True, max(self.limit - len(bucket), 0), 0

    async def prune(self) -> None:
        """定期清理空桶，避免长期运行内存膨胀。"""
        async with self._lock:
            now = time.monotonic()
            for key in list(self._hits.keys()):
                bucket = self._hits[key]
                while bucket and now - bucket[0] > self.window:
                    bucket.popleft()
                if not bucket:
                    self._hits.pop(key, None)
