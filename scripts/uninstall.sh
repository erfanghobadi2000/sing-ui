#!/usr/bin/env bash
set -Eeuo pipefail

[[ $EUID -eq 0 ]] || { echo "Run as root"; exit 1; }

systemctl disable --now sing-ui 2>/dev/null || true
rm -f /etc/systemd/system/sing-ui.service /usr/local/bin/sing-ui
systemctl daemon-reload

echo "Sing-UI service and launcher removed. Source/data under /usr/local/src/sing-ui were kept."
