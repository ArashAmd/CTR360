#!/usr/bin/env bash
set -eu

ROOT="$(cd "$(dirname "$0")" && pwd)"
FAIL=0

printf '%s\n' 'CTR360 Xbox 360 build preflight' '================================'

if ! command -v make >/dev/null 2>&1; then
  echo '[FAIL] make is not installed.'
  FAIL=1
else
  echo "[ OK ] make: $(command -v make)"
fi

if [ -z "${DEVKITXENON:-}" ]; then
  echo '[FAIL] DEVKITXENON is not set.'
  echo '       Expected a LibXenon install path, often /usr/local/xenon.'
  FAIL=1
else
  echo "[ OK ] DEVKITXENON=$DEVKITXENON"
  if [ ! -f "$DEVKITXENON/rules" ]; then
    echo "[FAIL] Missing $DEVKITXENON/rules"
    FAIL=1
  else
    echo "[ OK ] found $DEVKITXENON/rules"
  fi
fi

if command -v xenon-gcc >/dev/null 2>&1; then
  echo "[ OK ] xenon-gcc: $(command -v xenon-gcc)"
elif [ -n "${DEVKITXENON:-}" ] && [ -x "$DEVKITXENON/bin/xenon-gcc" ]; then
  echo "[ OK ] xenon-gcc: $DEVKITXENON/bin/xenon-gcc"
else
  echo '[FAIL] xenon-gcc was not found in PATH or DEVKITXENON/bin.'
  FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  cat <<'EOF'

Result: the Xbox 360 native build cannot start in this environment yet.
Install the Free60Project LibXenon toolchain on a Linux machine, then set:
  export DEVKITXENON="/usr/local/xenon"
  export PATH="$PATH:$DEVKITXENON/bin:$DEVKITXENON/usr/bin"
Then rerun this script and `make` from this directory.
Official setup instructions:
  https://github.com/Free60Project/libxenon
EOF
  exit 2
fi

printf '\n[ OK ] prerequisites found; trying native build...\n'
make -C "$ROOT" clean all
printf '\n[ OK ] build command completed. Expected output: %s/%s.elf32\n' "$ROOT" 'ctr360_boot_test'
