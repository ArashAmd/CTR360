#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo '[FAIL] Docker is not installed or is not available in PATH.' >&2
  echo 'Use a Linux/macOS host with Docker, or follow native/BUILD_ON_GITHUB_FA.md.' >&2
  exit 2
fi

if ! docker info >/dev/null 2>&1; then
  echo '[FAIL] Docker is installed but the daemon is not available.' >&2
  exit 2
fi

docker run --rm \
  -v "$ROOT:/app" \
  -w /app/native \
  free60/libxenon:latest \
  sh -lc 'set -eu; echo "DEVKITXENON=${DEVKITXENON:-unset}"; command -v xenon-gcc; test -n "${DEVKITXENON:-}"; test -f "$DEVKITXENON/rules"; make clean all; test -s ctr360_boot_test.elf32; file ctr360_boot_test.elf32'

test -s "$ROOT/native/ctr360_boot_test.elf32"
printf '\n[ OK ] Built: %s\n' "$ROOT/native/ctr360_boot_test.elf32"
