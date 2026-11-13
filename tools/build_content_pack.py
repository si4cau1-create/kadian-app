#!/usr/bin/env python3
"""把 assets/content_pack 打成可 OTA 的内容包 ZIP。

要点：
- manifest.json 的 fileHashes / checksum 由这里统一计算，手改无效
- 校验和算法与客户端一致：按路径排序，逐文件 sha256，再对整串 sha256
- 输出 dist/content_pack/kadian-base-<version>.zip

用法：
    python tools/build_content_pack.py
    python tools/build_content_pack.py --version 2026.12.1 --notes "新增 N4 词簇"
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PACK_DIR = ROOT / "assets" / "content_pack"
OUT_DIR = ROOT / "dist" / "content_pack"
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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", help="覆盖 manifest 里的 version")
    parser.add_argument("--notes", help="覆盖 manifest 里的 notes")
    parser.add_argument("--min-app", help="覆盖 minAppVersion")
    parser.add_argument("--out", help="输出目录，默认 dist/content_pack")
    args = parser.parse_args()

    manifest_path = PACK_DIR / "manifest.json"
    if not manifest_path.exists():
        print(f"[ERROR] 找不到 {manifest_path}", file=sys.stderr)
        return 1

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if args.version:
        manifest["version"] = args.version
    if args.notes:
        manifest["notes"] = args.notes
    if args.min_app:
        manifest["minAppVersion"] = args.min_app

    files: dict[str, bytes] = {}
    for name in TEXT_FILES:
        path = PACK_DIR / name
        if path.exists():
            files[name] = path.read_bytes()

    hashes = {name: sha256_bytes(data) for name, data in files.items()}
    manifest["fileHashes"] = hashes
    manifest["checksum"] = compute_checksum(hashes)

    # 回写 manifest，保证仓库内的资产与发布的包一致
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    out_dir = Path(args.out) if args.out else OUT_DIR
    out_dir.mkdir(parents=True, exist_ok=True)
    version = str(manifest.get("version", "0.0.0"))
    zip_path = out_dir / f"{manifest.get('packId', 'kadian-base')}-{version}.zip"

    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(
            "manifest.json",
            json.dumps(manifest, ensure_ascii=False, indent=2),
        )
        for name, data in files.items():
            zf.writestr(name, data)

    size = zip_path.stat().st_size
    print(f"[OK] {zip_path}")
    print(f"     version = {version}")
    print(f"     checksum = {manifest['checksum']}")
    print(f"     size = {size} bytes ({size / 1024:.1f} KB)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
