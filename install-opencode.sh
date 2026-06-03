#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

REPO="zexjpg/opencode-termux-auto"
VERSION="${1:-latest}"

log()  { printf '\033[1;32m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[install]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[install]\033[0m %s\n' "$*" >&2; exit 1; }

command -v dpkg >/dev/null 2>&1 || die "dpkg not found. Are you on Termux?"
command -v curl >/dev/null 2>&1 || die "curl not found. Install: apt install curl"

if [ "$(uname -m)" != "aarch64" ]; then
  die "Only aarch64 is supported. Detected: $(uname -m)"
fi

log "Installing OpenCode for Termux..."
log "Checking dependencies..."

apt install -y glibc-repo
apt update
apt install -y glibc openssl-glibc

log "Dependencies ready."

if [ "$VERSION" = "latest" ]; then
  log "Fetching latest version from GitHub..."
  API_URL="https://api.github.com/repos/$REPO/releases/latest"
  VERSION=$(curl -fsSL "$API_URL" | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])" 2>/dev/null || true)
  if [ -z "$VERSION" ]; then
    die "Failed to fetch latest version. Check network or specify version: ./install-opencode.sh v1.15.13"
  fi
  VERSION="${VERSION#v}"
  log "Latest version: $VERSION"
fi

VERSION="${VERSION#v}"
DEB_URL="https://github.com/$REPO/releases/download/v$VERSION/opencode_${VERSION}_aarch64.deb"
DEB_FILE="opencode_${VERSION}_aarch64.deb"

log "Downloading $DEB_FILE ..."
curl -fL -o "/tmp/$DEB_FILE" "$DEB_URL" || die "Download failed. Check version: $VERSION"

log "Installing..."
dpkg -i "/tmp/$DEB_FILE" || {
  warn "dpkg failed, fixing dependencies..."
  apt install -f -y
  dpkg -i "/tmp/$DEB_FILE"
}

rm -f "/tmp/$DEB_FILE"
log "Installation complete!"
log "Run: opencode --version"
