#!/usr/bin/env bash
set -Eeuo pipefail

NODE_VERSION="${NODE_VERSION:-22.23.3}"
GO_VERSION="${GO_VERSION:-1.26.8}"
TOOLCHAIN_ROOT="/opt/sing-ui-toolchain"

arch="$(uname -m)"
case "$arch" in
  x86_64) NODE_ARCH="x64"; GO_ARCH="amd64" ;;
  aarch64|arm64) NODE_ARCH="arm64"; GO_ARCH="arm64" ;;
  armv7l|armv7) NODE_ARCH="armv7l"; GO_ARCH="armv6l" ;;
  armv6l|armv6) NODE_ARCH="armv6l"; GO_ARCH="armv6l" ;;
  i386|i686) echo "Node.js 22 official Linux x86 binaries are not published; install a supported 64-bit userspace." >&2; exit 1 ;;
  s390x) NODE_ARCH="s390x"; GO_ARCH="s390x" ;;
  ppc64le) NODE_ARCH="ppc64le"; GO_ARCH="ppc64le" ;;
  *) echo "Unsupported Linux architecture: $arch" >&2; exit 1 ;;
esac

has_supported_node() {
  command -v node >/dev/null 2>&1 || return 1
  node -e 'const v=process.versions.node.split(".").map(Number); process.exit((v[0] > 22 || (v[0] === 22 && v[1] >= 12) || (v[0] === 20 && v[1] >= 19)) ? 0 : 1)' >/dev/null 2>&1
}

install_node() {
  local tarball="node-v$NODE_VERSION-linux-$NODE_ARCH.tar.xz"
  local url="https://nodejs.org/dist/v$NODE_VERSION/$tarball"
  local dest="$TOOLCHAIN_ROOT/node-v$NODE_VERSION"
  mkdir -p "$TOOLCHAIN_ROOT"
  if [[ ! -x "$dest/bin/node" ]]; then
    curl -fL --retry 3 -o "/tmp/$tarball" "$url"
    rm -rf "$dest"
    mkdir -p "$dest"
    tar -xJf "/tmp/$tarball" -C "$dest" --strip-components=1
    rm -f "/tmp/$tarball"
  fi
  ln -sfn "$dest" "$TOOLCHAIN_ROOT/node"
  ln -sfn "$TOOLCHAIN_ROOT/node/bin/node" /usr/local/bin/node
  ln -sfn "$TOOLCHAIN_ROOT/node/bin/npm" /usr/local/bin/npm
  [[ -x "$TOOLCHAIN_ROOT/node/bin/npx" ]] && ln -sfn "$TOOLCHAIN_ROOT/node/bin/npx" /usr/local/bin/npx
}

has_go() {
  command -v go >/dev/null 2>&1 || return 1
  go version >/dev/null 2>&1
}

install_go() {
  local tarball="go$GO_VERSION.linux-$GO_ARCH.tar.gz"
  local url="https://go.dev/dl/$tarball"
  curl -fL --retry 3 -o "/tmp/$tarball" "$url"
  rm -rf /usr/local/go
  tar -xzf "/tmp/$tarball" -C /usr/local
  rm -f "/tmp/$tarball"
  ln -sfn /usr/local/go/bin/go /usr/local/bin/go
  ln -sfn /usr/local/go/bin/gofmt /usr/local/bin/gofmt
}

if ! has_supported_node; then
  install_node
fi

if ! has_go; then
  install_go
fi

export PATH="/usr/local/go/bin:/usr/local/bin:$PATH"
node -v
npm -v
go version
