#!/usr/bin/env bash
set -Eeuo pipefail

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SUI="$ROOT/upstream/s-ui"
PATCH="$ROOT/patches"

[[ -d "$SUI/frontend/src" ]] || { echo "S-UI frontend is missing"; exit 1; }

copy_patch() {
  local src="$1" dst="$2"
  install -D -m 0644 "$PATCH/$src" "$SUI/frontend/src/$dst"
}

copy_patch "layouts/default/Default.vue" "layouts/default/Default.vue"
copy_patch "layouts/default/AppBar.vue" "layouts/default/AppBar.vue"
copy_patch "layouts/default/Drawer.vue" "layouts/default/Drawer.vue"
copy_patch "views/Login.vue" "views/Login.vue"
copy_patch "styles/sing-ui.scss" "styles/sing-ui.scss"

python3 - "$SUI/frontend/src/main.ts" <<'PY'
from pathlib import Path
p = Path(__import__('sys').argv[1])
s = p.read_text()
needle = "import 'notivue/animations.css'\n"
ins = needle + "import '@/styles/sing-ui.scss'\n"
if "@/styles/sing-ui.scss" not in s:
    s = s.replace(needle, ins)
p.write_text(s)
PY

echo "Sing-UI theme applied."
