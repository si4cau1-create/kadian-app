"""合规过滤：答案泄露、超纲术语、JSON 结构。

与客户端 `HintLeakGuard` 是同一套规则的两份实现——
验收要求「代理 + 客户端双重过滤」，宁可重复也不留单点。
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from typing import Any, Iterable

_SENTENCE_END = "。！？!?\n"

FALLBACK_HINT = (
    "这一级只给方向：先看空格前后的词性和搭配，再判断需要哪种形式；"
    "具体答案在你点「再看一层」后才出现。"
)

# N1/N2 常见高级语法（用于超纲检查：低等级学习者不该被这些术语轰炸）
ADVANCED_JA_TERMS = [
    "にもまして",
    "を皮切りに",
    "ずにはおかない",
    "ならでは",
    "に至るまで",
    "を余儀なくされる",
    "が早いか",
    "そばから",
    "ゆえあって",
    "んばかり",
    "たらんとする",
    "べくもない",
]

ADVANCED_EN_TERMS = [
    "notwithstanding",
    "insofar as",
    "whereby",
    "hitherto",
    "subjunctive",
    "gerundive",
    "counterfactual",
]


@dataclass
class LeakResult:
    safe: bool
    text: str
    hits: list[str] = field(default_factory=list)
    filtered: bool = False

    def to_dict(self) -> dict[str, Any]:
        return {"safe": self.safe, "hits": self.hits, "filtered": self.filtered}


def split_sentences(text: str) -> list[str]:
    out: list[str] = []
    buf: list[str] = []
    for ch in text:
        buf.append(ch)
        if ch in _SENTENCE_END:
            out.append("".join(buf))
            buf.clear()
    if buf:
        out.append("".join(buf))
    return out


def filter_answer_leak(
    text: str,
    *,
    level: int,
    keywords: Iterable[str],
    answer_label: str = "",
) -> LeakResult:
    """一级/二级提示里不允许出现答案原文；三级起放行。"""
    if level > 2:
        return LeakResult(safe=True, text=text)

    forbidden = {k.strip() for k in keywords if k and k.strip()}
    if answer_label.strip():
        forbidden.add(answer_label.strip())
    # 单字禁词（助词、字母）误杀率极高，只匹配长度 ≥2
    effective = [k for k in forbidden if len(k) >= 2]
    hits = [k for k in effective if k in text]
    if not hits:
        return LeakResult(safe=True, text=text)

    kept = [s for s in split_sentences(text) if not any(k in s for k in effective)]
    cleaned = "".join(kept).strip()
    if not cleaned:
        cleaned = FALLBACK_HINT
    return LeakResult(safe=False, text=cleaned, hits=hits, filtered=True)


def mask_live(text: str, *, keywords: Iterable[str], answer_label: str = "") -> str:
    """流式输出阶段的即时遮蔽（与客户端 maskLive 对齐）。"""
    forbidden = {k.strip() for k in keywords if k and len(k.strip()) >= 2}
    if answer_label.strip() and len(answer_label.strip()) >= 2:
        forbidden.add(answer_label.strip())
    result = text
    for word in forbidden:
        if word in result:
            result = result.replace(word, "＿" * len(word))
    return result


def scope_violations(text: str, *, subject: str, learner_level: int) -> list[str]:
    """超纲检查：低等级学习者不应被高级术语解释。

    日语 N3 用 N1 语法讲解、英语 B1 堆 C2 术语，都算超纲。
    """
    if learner_level >= 3:
        return []
    pool = ADVANCED_JA_TERMS if subject == "ja" else ADVANCED_EN_TERMS
    return [term for term in pool if term in text]


def looks_like_reveal(text: str) -> bool:
    """粗判是否直接给出答案（用于诊断官输出校验）。"""
    patterns = [
        r"正确答案(是|为)",
        r"应选\s*[A-D]",
        r"答案是",
        r"the answer is",
    ]
    lowered = text.lower()
    return any(re.search(p, text) or re.search(p, lowered) for p in patterns)


def ensure_json_object(raw: str, required: Iterable[str]) -> dict[str, Any]:
    """模型输出必须是 JSON 对象且包含必需键，否则抛 ValueError。

    客户端拿到非结构化内容会拒绝落库——这里先挡一层，省一次往返。
    """
    text = raw.strip()
    if text.startswith("```"):
        text = re.sub(r"^```[a-zA-Z]*\n?", "", text)
        text = re.sub(r"\n?```$", "", text).strip()
    try:
        data = json.loads(text)
    except json.JSONDecodeError as exc:  # pragma: no cover - 依赖模型行为
        raise ValueError(f"模型输出不是合法 JSON: {exc}") from exc
    if not isinstance(data, dict):
        raise ValueError("模型输出必须是 JSON 对象")
    missing = [key for key in required if key not in data]
    if missing:
        raise ValueError(f"模型输出缺少字段: {', '.join(missing)}")
    return data
