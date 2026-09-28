#!/usr/bin/env bash
set -euo pipefail
cd /usr/local/src/sing-ui/upstream/s-ui
exec ./s-ui.sh "$@"
