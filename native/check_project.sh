#!/usr/bin/env bash
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
command -v node >/dev/null 2>&1 || { echo '[FAIL] Node.js is required for the JavaScript syntax check.' >&2; exit 2; }
python3 - "$ROOT/prototype11.html" <<'PY'
import re,sys,pathlib
p=pathlib.Path(sys.argv[1]); s=p.read_text()
blocks=re.findall(r'<script>(.*?)</script>',s,re.S)
if not blocks: raise SystemExit('[FAIL] No inline JavaScript found')
pathlib.Path('/tmp/ctr360-prototype-check.js').write_text('\n'.join(blocks))
required=['id="minimap"','id="finish"','data-key="w"','hazardMesh','prevAngle','fruitPickups','boostPads','collisionCooldown','id="position"','playerProgress','data-difficulty="0"','data-difficulty="2"','r.lap','id="drift"','driftSparkA','دریفت کامل شد','catchup','aiSeed']
missing=[x for x in required if x not in s]
if missing: raise SystemExit('[FAIL] Missing expected features: '+', '.join(missing))
print('[ OK ] HTML has expected prototype features')
PY
node --check /tmp/ctr360-prototype-check.js
echo '[ OK ] JavaScript syntax check passed'
if [ -s "$ROOT/native/ctr360_boot_test.elf32" ]; then
  echo '[ OK ] Existing ELF artifact found'
else
  echo '[INFO] No native ELF artifact exists yet; this is expected until Xenon Toolchain is available.'
fi


if grep -q 'hazardCooldown' "$ROOT/prototype11.html" && grep -q 'Look ahead for a hazard' "$ROOT/prototype11.html"; then echo '[ OK ] Hazard cooldown and rival avoidance found'; else echo '[FAIL] New obstacle logic missing'; exit 1; fi
