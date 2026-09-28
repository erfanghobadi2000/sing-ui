#!/usr/bin/env bash
set -Eeuo pipefail

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SUI="$ROOT/upstream/s-ui"
SUI_REF="${SUI_REF:-main}"

if [[ ! -d "$SUI/.git" ]]; then
  mkdir -p "$ROOT/upstream"
  rm -rf "$SUI"
  git clone --recurse-submodules --branch "$SUI_REF" https://github.com/alireza0/s-ui.git "$SUI"
else
  git -C "$SUI" fetch --all --tags
  git -C "$SUI" checkout "$SUI_REF"
  git -C "$SUI" submodule update --init --recursive
fi

bash "$ROOT/scripts/apply-theme.sh"

cd "$SUI"
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
