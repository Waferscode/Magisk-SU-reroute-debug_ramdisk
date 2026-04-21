#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/su-reroute-debug-ramdisk-v1.0.zip"

rm -f "$OUT"

(
  cd "$ROOT"
  zip -qr "$OUT" module.prop post-fs-data.sh system README.md
)

echo "$OUT"
