#!/usr/bin/env python3
"""把 assets/content_pack/<subject>/ 打成可 OTA 的单学科内容包 ZIP。

产品是单学科学习实例：日语、英语各一份内容包，互不混用。
打包脚本逐学科出包，输出 dist/content_pack/<packId>-<version>.zip。

要点：
- manifest.json 的 fileHashes / checksum 由这里统一计算，手改无效
- 校验和算法与客户端一致：按路径排序，逐文件 sha256（换行归一 LF），再对整串 sha256
- 打包时会复核包内不出现另一学科的节点/题目/词条（防止以后误合并）

用法：
    python tools/build_content_pack.py
    python tools/build_content_pack.py --subject japanese --version 2026.12.1
    python tools/build_content_pack.py --notes "新增 N4 词簇"
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PACKS_ROOT = ROOT / "assets" / "content_pack"
OUT_DIR = ROOT / "dist" / "content_pack"
TEXT_FILES = [
    "graph.json",
    "items.json",
    "vocab.json",
    "achievements.json",
    "calibration_params.json",
]
SUBJECTS = ("japanese", "english")


def normalize(data: bytes) -> bytes:
    """与 Dart 端一致：换行归一 LF 后再算哈希。"""
    return data.replace(b"\r\n", b"\n")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(normalize(data)).hexdigest()


def compute_checksum(hashes: dict[str, str]) -> str:
    buffer = "".join(f"{path}:{hashes[path]}\n" for path in sorted(hashes))
    return hashlib.sha256(buffer.encode()).hexdigest()


def scan_cross_subject(subject: str, files: dict[str, bytes]) -> list[str]:
    """检查包内容是否混入了另一学科的实体。"""
    markers = [f"{other}." for other in SUBJECTS if other != subject]
    problems: list[str] = []

    def bad(entity: str, eid: str) -> None:
        if any(eid.startswith(m) for m in markers):
            problems.append(f"跨学科{entity} {eid}")

    graph = json.loads(files["graph.json"].decode("utf-8"))
    for node in graph.get("nodes", []):
        bad("节点", node.get("id", ""))
    for cluster in graph.get("clusters", []):
        bad("簇", cluster.get("id", ""))
    items = json.loads(files["items.json"].decode("utf-8"))
    for item in items.get("items", []):
        bad("题目", item.get("id", ""))
    vocab = json.loads(files["vocab.json"].decode("utf-8"))
    for word in vocab.get("vocab", []):
        bad("词条", word.get("id", ""))
    return problems


def build_one(pack_dir: Path, args: argparse.Namespace) -> int:
    manifest_path = pack_dir / "manifest.json"
    if not manifest_path.exists():
        print(f"[ERROR] 找不到 {manifest_path}", file=sys.stderr)
        return 1

    subject = pack_dir.name
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if args.version:
        manifest["version"] = args.version
    if args.notes:
        manifest["notes"] = args.notes
    if args.min_app:
        manifest["minAppVersion"] = args.min_app

    files: dict[str, bytes] = {}
    for name in TEXT_FILES:
        path = pack_dir / name
        if path.exists():
            files[name] = path.read_bytes()
    if not files:
        print(f"[ERROR] {pack_dir} 里没有内容文件", file=sys.stderr)
        return 1

    problems = scan_cross_subject(subject, files)
    if problems:
        shown = "；".join(problems[:3])
        print(f"[ERROR] {subject} 包不纯：{shown}", file=sys.stderr)
        return 1

    hashes = {name: sha256_bytes(data) for name, data in files.items()}
    manifest["fileHashes"] = hashes
    manifest["checksum"] = compute_checksum(hashes)
    manifest["subject"] = subject

    # 回写 manifest，保证仓库内的资产与发布的包一致
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    out_dir = Path(args.out) if args.out else OUT_DIR
    out_dir.mkdir(parents=True, exist_ok=True)
    version = str(manifest.get("version", "0.0.0"))
    pack_id = manifest.get("packId", f"kadian.{subject}")
    zip_path = out_dir / f"{pack_id}-{version}.zip"

    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(
            "manifest.json",
            json.dumps(manifest, ensure_ascii=False, indent=2),
        )
        for name, data in files.items():
            zf.writestr(name, data)

    size = zip_path.stat().st_size
    print(f"[OK] {zip_path}")
    print(f"     subject = {subject}")
    print(f"     version = {version}")
    print(f"     checksum = {manifest['checksum']}")
    print(f"     size = {size} bytes ({size / 1024:.1f} KB)")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--subject", choices=SUBJECTS, help="只打指定学科")
    parser.add_argument("--version", help="覆盖 manifest 里的 version")
    parser.add_argument("--notes", help="覆盖 manifest 里的 notes")
    parser.add_argument("--min-app", help="覆盖 minAppVersion")
    parser.add_argument("--out", help="输出目录，默认 dist/content_pack")
    args = parser.parse_args()

    subjects = (args.subject,) if args.subject else SUBJECTS
    rc = 0
    for subject in subjects:
        pack_dir = PACKS_ROOT / subject
        if not pack_dir.is_dir():
            print(f"[WARN] 跳过不存在的 {pack_dir}")
            continue
        rc = max(rc, build_one(pack_dir, args))
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
