#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "$0")" && pwd)"
OK=0
WARN=0
printf '%s\n' 'CTR360 Xbox 360 native-build diagnostics' '========================================'
for cmd in make gcc git; do
  if command -v "$cmd" >/dev/null 2>&1; then printf '[ OK ] %-8s %s\n' "$cmd" "$(command -v "$cmd")"; else printf '[MISSING] %s\n' "$cmd"; WARN=1; fi
done
if command -v xenon-gcc >/dev/null 2>&1; then
  printf '[ OK ] xenon-gcc %s\n' "$(command -v xenon-gcc)"
elif [ -n "${DEVKITXENON:-}" ] && [ -x "$DEVKITXENON/bin/xenon-gcc" ]; then
  printf '[ OK ] xenon-gcc %s\n' "$DEVKITXENON/bin/xenon-gcc"
else
  echo '[MISSING] xenon-gcc (Xbox 360 cross-compiler)'; WARN=1
fi
if [ -n "${DEVKITXENON:-}" ]; then
  echo "[INFO] DEVKITXENON=$DEVKITXENON"
  [ -f "$DEVKITXENON/rules" ] && echo '[ OK ] LibXenon rules file found' || { echo '[MISSING] $DEVKITXENON/rules'; WARN=1; }
else
  echo '[MISSING] DEVKITXENON environment variable'; WARN=1
fi
if command -v docker >/dev/null 2>&1; then echo "[ OK ] Docker $(docker --version 2>/dev/null || true)"; else echo '[INFO] Docker unavailable; container build route cannot run here'; fi
if [ -s "$ROOT/ctr360_boot_test.elf32" ]; then echo '[ OK ] Native ELF artifact exists'; else echo '[INFO] No native ELF artifact found'; fi
if [ "$WARN" -eq 0 ]; then
  echo '[ OK ] Prerequisites look present. Run ./build.sh to attempt compilation.'
else
  cat <<'EOF'

Result: native Xbox 360 compilation is blocked until the missing LibXenon toolchain is installed.
This project currently contains a boot-test program, not the 3D racing game.
Do not rename a browser HTML file to an ELF/XEX or try to launch it in XeLL.
Setup reference: https://github.com/Free60Project/libxenon
EOF
fi
exit 0
