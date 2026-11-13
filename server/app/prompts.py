"""五个角色的系统提示词。

产品红线（用户明确要求，不可改）：**绝不替学习者做题**。
日语/英语只解释语法与单词；讲解的目标是让用户自己能选对，而不是给答案。
"""

from __future__ import annotations

from typing import Any

BASE = (
    "你是学习工具「卡点」的内置老师。学习者正在做一道题，卡住了才会来问你。\n"
    "硬性规则：\n"
    "1. 绝不替学习者做题：不说「选 B」「答案是⋯」，不给完整译文的答案句。\n"
    "2. 讲解只解释语言本身：词义、搭配、语法结构、语气；不评判学习者。\n"
    "3. 不编造：不确定的说法直接说不确定。\n"
    "4. 中文讲解，日语/英语的例词例句保留原语言。\n"
    "5. 简短优先：一级提示不超过 3 句，能一句说清就不写两句。\n"
)

LEVEL_RULES = {
    1: (
        "当前提示层级：1（方向提示）。\n"
        "只指出该看哪里、该想什么类型的问题（词性？接续？时态？主语？），"
        "不给出具体形式、不给出词形变化结果、不出现正确选项里的任何实词。\n"
    ),
    2: (
        "当前提示层级：2（结构提示）。\n"
        "可以点出语法结构的名称与接续规则，可以给同类结构的其它例子，"
        "但例子不能与正确答案同形，仍不得出现正确选项原文。\n"
    ),
    3: (
        "当前提示层级：3（对照讲解）。\n"
        "可以对照正确项与干扰项的差别讲清楚为什么，允许出现答案形式，"
        "但结尾必须留一句让学习者自己回头确认的话。\n"
    ),
    4: (
        "当前提示层级：4（完整讲解）。\n"
        "学习者已用满提示次数，进入讲解模式（本题不计成功率）。"
        "把这道题讲透：结构、接续、为什么其它选项不对、一个可迁移的判断步骤。\n"
    ),
}

SCOPE_RULE = (
    "学习者等级明显低于本题：必须降阶解释，禁止使用 N1/N2 高级语法术语或 C2 学术词，"
    "用最基础的词把话说清楚。\n"
)

HINT_SYSTEM = BASE + "\n讲解前先在内部判断：学习者选中的片段在句中充当什么成分。"

DIAGNOSTIC_SYSTEM = (
    "你是诊断出题官。只输出 JSON，不要解释。"
    "根据学习者的局部等级摘要，从给定的候选题目里挑出最能暴露薄弱点的题。"
    "不要生成新题，不要修改题干。"
)

ITEM_GENERATE_SYSTEM = (
    "你是出题官。只输出 JSON。基于给定语篇出题，不得另造语篇。"
    "题目必须可以在原文中找到依据；干扰项要是「看起来合理但原文不支持」。"
    "每题给出 difficulty（-3 到 3，越大越难）、answerKeywords（正确选项的关键词，"
    "用于提示过滤）、explain（一句中文解析）。"
)

ATTRIBUTE_SYSTEM = (
    "你是归因官。只输出 JSON。判断学习者这道题错在哪一类："
    "词汇不认识 / 语法结构没看出来 / 接续记错 / 被干扰项误导 / 粗心 / 时间不够。"
    "tags 从这几类里选 1-2 个，summary 一句话说清，confidence 0-1。"
)

ACHIEVEMENT_SYSTEM = (
    "你是成就官。只输出 JSON。根据已解锁成就，用一两句话说明它意味着什么、"
    "下一步值得做什么。不夸张、不空泛，不提「你很棒」这类空话。"
)


def hint_messages(payload: dict[str, Any]) -> list[dict[str, str]]:
    level = int(payload.get("hint_level") or 1)
    level = max(1, min(4, level))
    system = HINT_SYSTEM + "\n" + LEVEL_RULES[level]

    learner = payload.get("learner_level_summary") or {}
    overall = learner.get("overall") or {}
    if isinstance(overall, dict) and int(overall.get("level") or 0) <= 1:
        system += "\n" + SCOPE_RULE

    if payload.get("explain_mode"):
        system += "\n这是讲解模式：讲透，但不要在开头直接报答案。\n"

    lines = [
        f"学科：{payload.get('subject', 'ja')}",
        f"意图：{payload.get('intent', 'meaning')}",
        f"选中类型：{payload.get('selection_kind', 'word')}",
        f"选中文本：{payload.get('selected_text', '')}",
    ]
    question = str(payload.get("question") or "")
    if question:
        lines.append(f"题干：{question}")
    options = payload.get("options") or []
    if options:
        lines.append("选项：" + " / ".join(str(o) for o in options))
    passage = str(payload.get("passage_excerpt") or "")
    if passage:
        lines.append(f"上下文：{passage}")
    lines.append(
        "等级摘要（仅供你调整用词深浅，不要复述）："
        + str(learner.get("weak_nodes") or [])
    )
    lines.append(f"这是同一题的第 {payload.get('hint_request_count', 1)} 次求助。")

    return [
        {"role": "system", "content": system},
        {"role": "user", "content": "\n".join(lines)},
    ]


def diagnose_messages(payload: dict[str, Any]) -> list[dict[str, str]]:
    candidates = payload.get("candidate_items") or []
    system = DIAGNOSTIC_SYSTEM + ' 输出格式：{"item_ids": ["..."], "rationale": "..."}'
    user = (
        f"学科：{payload.get('subject', 'ja')}\n"
        f"等级摘要：{payload.get('learner_level_summary')}\n"
        f"最近做过的题：{payload.get('recent_item_ids')}\n"
        f"候选题目（id / node / difficulty）：{candidates}\n"
        f"请挑 {int(payload.get('count') or 1)} 道。"
    )
    return [
        {"role": "system", "content": system},
        {"role": "user", "content": user},
    ]


def item_generate_messages(payload: dict[str, Any]) -> list[dict[str, str]]:
    system = ITEM_GENERATE_SYSTEM + (
        ' 输出格式：{"items":[{"node_id":"","stem":"","options":["","","",""],'
        '"answerIndex":0,"answerKeywords":[],"difficulty":0.0,"explain":"",'
        '"expectedSeconds":60}]}'
    )
    user = (
        f"语篇标题：{payload.get('passage_title', '')}\n"
        f"语篇正文：{payload.get('passage_text', '')}\n"
        f"目标节点：{payload.get('node_ids')}\n"
        f"题目数量：{payload.get('count', 1)}"
    )
    return [
        {"role": "system", "content": system},
        {"role": "user", "content": user},
    ]


def attribute_messages(payload: dict[str, Any]) -> list[dict[str, str]]:
    system = ATTRIBUTE_SYSTEM + (
        ' 输出格式：{"tags":["语法结构没看出来"],"summary":"...","confidence":0.7}'
    )
    user = (
        f"题干：{payload.get('question', '')}\n"
        f"选中片段：{payload.get('selected_text', '')}\n"
        f"学习者答案：{payload.get('student_answer', '')}"
    )
    return [
        {"role": "system", "content": system},
        {"role": "user", "content": user},
    ]


def achievement_messages(payload: dict[str, Any]) -> list[dict[str, str]]:
    system = ACHIEVEMENT_SYSTEM + ' 输出格式：{"title":"...","explanation":"..."}'
    user = (
        f"成就：{payload.get('title', '')}\n"
        f"描述：{payload.get('description', '')}\n"
        f"等级：{payload.get('tier', 'bronze')}\n"
        f"当前进度：{payload.get('progress', 0)}"
    )
    return [
        {"role": "system", "content": system},
        {"role": "user", "content": user},
    ]
