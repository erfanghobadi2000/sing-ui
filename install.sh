#!/usr/bin/env bash
set -Eeuo pipefail

REPO="https://github.com/erfanghobadi2000/sing-ui.git"
REF="main"
INSTALL_DIR="/usr/local/src/sing-ui"
UPSTREAM_DIR="$INSTALL_DIR/upstream/s-ui"
SERVICE_FILE="/etc/systemd/system/sing-ui.service"

die() { echo "[sing-ui] ERROR: $*" >&2; exit 1; }
info() { echo "[sing-ui] $*"; }

[[ $EUID -eq 0 ]] || die "Run as root: sudo bash install.sh"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) REF="${2:?missing version}"; shift 2 ;;
    --dir) INSTALL_DIR="${2:?missing directory}"; shift 2 ;;
    --help|-h)
      echo "Usage: install.sh [--version <git-ref>] [--dir <install-source-dir>]"
      exit 0
      ;;
    *) die "Unknown option: $1" ;;
  esac
done

export DEBIAN_FRONTEND=noninteractive

install_base_deps() {
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y --no-install-recommends git curl ca-certificates build-essential gcc g++ make pkg-config nodejs npm
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y git curl ca-certificates gcc gcc-c++ make nodejs npm
  elif command -v yum >/dev/null 2>&1; then
    yum install -y git curl ca-certificates gcc gcc-c++ make nodejs npm
  elif command -v apk >/dev/null 2>&1; then
    apk add --no-cache git curl ca-certificates build-base nodejs npm bash
  else
    die "Unsupported package manager. Install git, curl, gcc, make, nodejs and npm manually."
  fi
}

install_base_deps

mkdir -p "$(dirname "$INSTALL_DIR")"
if [[ -d "$INSTALL_DIR/.git" ]]; then
  info "Updating existing source tree"
  git -C "$INSTALL_DIR" fetch --all --tags
  git -C "$INSTALL_DIR" checkout "$REF"
  git -C "$INSTALL_DIR" pull --ff-only || true
else
  rm -rf "$INSTALL_DIR"
  info "Cloning Sing-UI"
  git clone --recurse-submodules --branch "$REF" "$REPO" "$INSTALL_DIR"
fi

git -C "$INSTALL_DIR" submodule update --init --recursive

[[ -d "$UPSTREAM_DIR" ]] || die "S-UI source was not initialized"

bash "$INSTALL_DIR/scripts/apply-theme.sh"
bash "$INSTALL_DIR/scripts/build.sh"

install -m 0755 "$UPSTREAM_DIR/sui" /usr/local/bin/sing-ui
install -m 0755 "$INSTALL_DIR/scripts/sing-ui.sh" /usr/local/bin/sing-ui

cat > "$SERVICE_FILE" <<'UNIT'
[Unit]
Description=Sing-UI panel (S-UI + Sing-Box)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/usr/local/src/sing-ui/upstream/s-ui
Environment=SUI_DB_FOLDER=db
ExecStart=/usr/local/bin/sing-ui
Restart=on-failure
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now sing-ui

info "Installation complete."
echo
echo "Check: systemctl status sing-ui --no-pager"
echo "Menu:  sing-ui"
echo "Logs:  journalctl -u sing-ui -e --no-pager"
