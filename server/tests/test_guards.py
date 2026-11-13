"""合规过滤的单元测试：防泄漏、超纲、JSON 校验。

运行：cd server && pytest -q
"""

from __future__ import annotations

import pytest

from app.guards import (
    ensure_json_object,
    filter_answer_leak,
    mask_live,
    scope_violations,
    split_sentences,
)


class TestAnswerLeak:
    def test_level1_drops_sentence_with_keyword(self):
        result = filter_answer_leak(
            "先看空格前面是不是动词。这里应该用「磨いて」的形式。再看接续。",
            level=1,
            keywords=["磨いて"],
        )
        assert result.safe is False
        assert result.filtered is True
        assert "磨いて" not in result.text
        assert "先看空格前面" in result.text
        assert "磨いて" in result.hits

    def test_level1_blocks_answer_label(self):
        result = filter_answer_leak(
            "答案就是「勉強して」这一项。", level=1, keywords=[], answer_label="勉強して"
        )
        assert result.safe is False
        assert "勉強して" not in result.text

    def test_level2_also_filtered(self):
        result = filter_answer_leak(
            "接续是「磨いて」。", level=2, keywords=["磨いて"]
        )
        assert result.safe is False

    def test_level3_allows_answer(self):
        result = filter_answer_leak(
            "完整讲解：这里用「磨いて」连接后续动作。", level=3, keywords=["磨いて"]
        )
        assert result.safe is True
        assert "磨いて" in result.text

    def test_all_sentences_dropped_falls_back(self):
        result = filter_answer_leak("磨いて。", level=1, keywords=["磨いて"])
        assert result.safe is False
        assert result.text
        assert "磨いて" not in result.text

    def test_single_char_keywords_do_not_trigger(self):
        result = filter_answer_leak(
            "看助词「は」提示主语。", level=1, keywords=["は"]
        )
        assert result.safe is True

    def test_empty_keywords_is_safe(self):
        result = filter_answer_leak("随便讲讲。", level=1, keywords=[])
        assert result.safe is True

    def test_mask_live_replaces_keyword(self):
        masked = mask_live("这里应该用磨いて，然后接から。", keywords=["磨いて"])
        assert "磨いて" not in masked
        assert "＿" in masked


class TestScope:
    def test_advanced_terms_flagged_for_low_level(self):
        hits = scope_violations(
            "这里用「にもまして」更自然。", subject="ja", learner_level=1
        )
        assert hits == ["にもまして"]

    def test_high_level_not_flagged(self):
        hits = scope_violations(
            "这里用「にもまして」更自然。", subject="ja", learner_level=3
        )
        assert hits == []

    def test_english_terms(self):
        hits = scope_violations(
            "This is a counterfactual reading.", subject="en", learner_level=1
        )
        assert hits


class TestJson:
    def test_parses_plain_json(self):
        data = ensure_json_object('{"tags": ["x"], "summary": "y"}', ["tags", "summary"])
        assert data["summary"] == "y"

    def test_strips_code_fence(self):
        data = ensure_json_object('```json\n{"tags": []}\n```', ["tags"])
        assert data["tags"] == []

    def test_missing_field_raises(self):
        with pytest.raises(ValueError, match="缺少字段"):
            ensure_json_object('{"tags": []}', ["tags", "summary"])

    def test_non_object_raises(self):
        with pytest.raises(ValueError):
            ensure_json_object("[1, 2]", ["tags"])


def test_split_sentences_keeps_punctuation():
    assert split_sentences("甲。乙！丙") == ["甲。", "乙！", "丙"]
