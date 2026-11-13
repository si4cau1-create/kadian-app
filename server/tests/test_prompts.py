from __future__ import annotations

from app import prompts


def _payload(**overrides):
    base = {
        "subject": "ja",
        "intent": "meaning",
        "selection_kind": "word",
        "selected_text": "手続き",
        "question": "市役所で転入の＿＿をした。",
        "options": ["手続き", "手数", "手順", "手段"],
        "passage_excerpt": "市役所の窓口で、転入の手続きをした。",
        "hint_level": 1,
        "hint_request_count": 1,
        "learner_level_summary": {
            "overall": {"level": 2, "label": "半会"},
            "weak_nodes": ["ja.g.te"],
        },
    }
    base.update(overrides)
    return base


def test_level1_prompt_forbids_answer():
    messages = prompts.hint_messages(_payload(hint_level=1))
    system = messages[0]["content"]
    assert "绝不替学习者做题" in system
    assert "方向提示" in system
    assert "不出现正确选项里的任何实词" in system


def test_level4_prompt_enters_explain_mode():
    messages = prompts.hint_messages(_payload(hint_level=4))
    system = messages[0]["content"]
    assert "完整讲解" in system
    assert "讲解模式" in system


def test_low_level_gets_scope_rule():
    messages = prompts.hint_messages(
        _payload(learner_level_summary={"overall": {"level": 1}})
    )
    assert "降阶解释" in messages[0]["content"]


def test_high_level_has_no_scope_rule():
    messages = prompts.hint_messages(
        _payload(learner_level_summary={"overall": {"level": 4}})
    )
    assert "降阶解释" not in messages[0]["content"]


def test_user_message_carries_context_but_not_events():
    messages = prompts.hint_messages(_payload())
    user = messages[1]["content"]
    assert "手続き" in user
    assert "市役所" in user
    assert "第 1 次求助" in user


def test_diagnose_prompt_demands_json():
    messages = prompts.diagnose_messages(
        {
            "subject": "ja",
            "learner_level_summary": {"overall": {"level": 2}},
            "recent_item_ids": ["i1"],
            "candidate_items": [{"id": "i2", "node": "n1", "difficulty": 0.2}],
            "count": 1,
        }
    )
    assert "JSON" in messages[0]["content"]
    assert "item_ids" in messages[0]["content"]


def test_attribute_prompt_lists_error_categories():
    messages = prompts.attribute_messages({"question": "q", "selected_text": "s"})
    system = messages[0]["content"]
    assert "语法结构没看出来" in system
    assert "JSON" in system


def test_achievement_prompt_forbids_empty_praise():
    messages = prompts.achievement_messages({"title": "第一步"})
    assert "不夸张" in messages[0]["content"]
