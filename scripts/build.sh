#!/usr/bin/env bash
set -Eeuo pipefail

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SUI="$ROOT/upstream/s-ui"

[[ -d "$SUI" ]] || { echo "S-UI submodule missing"; exit 1; }

cd "$SUI"
git submodule update --init --recursive
bash "$ROOT/scripts/apply-theme.sh"

if [[ ! -d frontend/node_modules ]]; then
  (cd frontend && npm install)
fi

(cd frontend && npm run build)

rm -rf web/html/*
mkdir -p web/html
cp -R frontend/dist/* web/html/

. "$SUI/build-tags.sh"
TAGS=$(tags_for dev)
LDFLAGS=$(ldflags_for dev)
go build -ldflags "$LDFLAGS -extldflags \"-Wl,-no_warn_duplicate_libraries\"" -tags "$TAGS" -o sui main.go

echo "Build complete: $SUI/sui"
