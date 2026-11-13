#!/usr/bin/env python3
"""把混合学科的内容包拆成 per-subject 的两份。

产品层是「单学科学习实例」：客户端选定学科后只加载该学科的内容包，
图谱、题库、词簇、成就都在本学科内闭环，不存在跨学科引用。

拆分规则：
- 节点/簇/轨道按 graph.json 里的 subjectId 归属
- 题目按 nodeId 反查所属节点
- 语篇按 passage.subjectId
- 词簇按 clusterId 反查所属簇（簇不在本学科即丢弃）
- 成就定义是学科无关的指标，复制一份并加学科命名空间：
    id    -> "<subject>.<原 id>"
    subjectId 字段补上
- 校准参数原样复制

校验和算法与客户端 lib/core/content_pack/loader.dart 的 computeChecksum 一致：
先按路径排序，逐文件 sha256（内容按 LF 归一），再把 "<path>:<hash>\\n" 拼起来求 sha256。

用法：
    python tools/split_content_pack.py
    python tools/split_content_pack.py --version 2026.12.1
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PACK_DIR = ROOT / "assets" / "content_pack"

# 内容包 subjectId -> (客户端 Subject.id, packId, 展示名, 备注)
SUBJECTS = {
    "ja": (
        "japanese",
        "kadian.japanese",
        "日语",
        "日语 N3 五轨：语法 / 词汇 / 阅读 / 听力 / 写作",
    ),
    "en": (
        "english",
        "kadian.english",
        "英语",
        "英语 B1：阅读 + 语法 / 分词",
    ),
}

TEXT_FILES = [
    "graph.json",
    "items.json",
    "vocab.json",
    "achievements.json",
    "calibration_params.json",
]


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def compute_checksum(hashes: dict[str, str]) -> str:
    buffer = "".join(f"{path}:{hashes[path]}\n" for path in sorted(hashes))
    return sha256_bytes(buffer.encode())


def dump_json(value: object) -> bytes:
    """序列化成 LF 结尾的 UTF-8 字节，杜绝平台换行差异影响校验和。"""
    text = json.dumps(value, ensure_ascii=False, indent=2) + "\n"
    return text.replace("\r\n", "\n").encode("utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", help="内容包版本，默认沿用现有 manifest")
    parser.add_argument("--min-app", help="最低客户端版本")
    args = parser.parse_args()

    legacy_manifest_path = PACK_DIR / "manifest.json"
    legacy_manifest = {}
    if legacy_manifest_path.exists():
        legacy_manifest = json.loads(
            legacy_manifest_path.read_text(encoding="utf-8")
        )
    version = args.version or legacy_manifest.get("version", "2026.11.1")
    min_app = args.min_app or "4.0.0"
    engine_version = legacy_manifest.get("engineVersion", "1.0.0")

    graph = json.loads((PACK_DIR / "graph.json").read_text(encoding="utf-8"))
    items_doc = json.loads((PACK_DIR / "items.json").read_text(encoding="utf-8"))
    vocab_doc = json.loads((PACK_DIR / "vocab.json").read_text(encoding="utf-8"))
    ach_doc = json.loads(
        (PACK_DIR / "achievements.json").read_text(encoding="utf-8")
    )
    cal_doc = json.loads(
        (PACK_DIR / "calibration_params.json").read_text(encoding="utf-8")
    )

    for prefix, (subject_id, pack_id, title, note) in SUBJECTS.items():
        clusters = [
            c for c in graph["clusters"] if c.get("subjectId") == prefix
        ]
        cluster_ids = {c["id"] for c in clusters}
        nodes = [n for n in graph["nodes"] if n.get("clusterId") in cluster_ids]
        node_ids = {n["id"] for n in nodes}

        tracks = [t for t in graph["tracks"] if t.get("subjectId") == prefix]
        subjects = [s for s in graph["subjects"] if s.get("id") == prefix]

        if not nodes:
            print(f"[WARN] {prefix} 没有任何节点，跳过", file=sys.stderr)
            continue

        items = [i for i in items_doc["items"] if i.get("nodeId") in node_ids]
        passages = [
            p
            for p in items_doc.get("passages", [])
            if p.get("subjectId") == prefix
        ]
        # 注意：词条的 clusterId 实际指向节点 id（如 ja.v.admin），不是簇 id
        vocab = [
            w for w in vocab_doc["vocab"] if w.get("clusterId") in node_ids
        ]

        achievements = []
        for a in ach_doc["achievements"]:
            clone = dict(a)
            clone["id"] = f"{subject_id}.{a['id']}"
            clone["subjectId"] = subject_id
            achievements.append(clone)

        out_dir = PACK_DIR / subject_id
        if out_dir.exists():
            shutil.rmtree(out_dir)
        out_dir.mkdir(parents=True)

        files: dict[str, bytes] = {
            "graph.json": dump_json(
                {
                    "subjects": subjects,
                    "tracks": tracks,
                    "clusters": clusters,
                    "nodes": nodes,
                }
            ),
            "items.json": dump_json({"passages": passages, "items": items}),
            "vocab.json": dump_json({"vocab": vocab}),
            "achievements.json": dump_json({"achievements": achievements}),
            "calibration_params.json": dump_json(cal_doc),
        }

        for name, data in files.items():
            (out_dir / name).write_bytes(data)

        hashes = {name: sha256_bytes(data) for name, data in files.items()}
        checksum = compute_checksum(hashes)

        manifest = {
            "packId": pack_id,
            "subject": subject_id,
            "version": version,
            "minAppVersion": min_app,
            "engineVersion": engine_version,
            "createdAt": "2026-11-14T00:00:00Z",
            "checksum": checksum,
            "notes": f"{title}单学科内容包：{note}。本包只含本学科节点，不可与其他学科混用。",
            "fileHashes": hashes,
        }
        (out_dir / "manifest.json").write_bytes(dump_json(manifest))

        print(
            f"[OK] {subject_id:9s} nodes={len(nodes):2d} clusters={len(clusters)} "
            f"items={len(items):2d} passages={len(passages)} vocab={len(vocab):2d} "
            f"achievements={len(achievements)}"
        )
        print(f"     {out_dir}")
        print(f"     checksum = {checksum}")

    # 旧混合包的文件已拆走，删掉避免被误加载
    for name in TEXT_FILES + ["manifest.json"]:
        stale = PACK_DIR / name
        if stale.exists():
            stale.unlink()
            print(f"[CLEAN] 移除混合包残留 {name}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
