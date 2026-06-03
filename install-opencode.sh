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

apt install -y glibc-repo 2>/dev/null
apt update 2>/dev/null
apt install -y glibc openssl-glibc 2>/dev/null

log "Dependencies ready."

if [ "$VERSION" = "latest" ]; then
  log "Fetching latest version from GitHub..."
  API_URL="https://api.github.com/repos/$REPO/releases/latest"
  VERSION=$(curl -fsSL "$API_URL" | grep -o '"tag_name":"[^"]*"' | cut -d'"' -f4)
  if [ -z "$VERSION" ]; then
    die "Failed to fetch latest version. Try: ./install-opencode.sh 1.15.13"
  fi
  VERSION="${VERSION#v}"
  log "Latest version: $VERSION"
fi

VERSION="${VERSION#v}"
DEB_URL="https://github.com/$REPO/releases/download/v$VERSION/opencode_${VERSION}_aarch64.deb"
DEB_FILE="opencode_${VERSION}_aarch64.deb"

log "Downloading $DEB_FILE ..."
curl -fL -o "/tmp/$DEB_FILE" "$DEB_URL" || die "Download failed."

log "Installing..."
dpkg -i "/tmp/$DEB_FILE" || {
  warn "Fixing dependencies..."
  apt install -f -y
  dpkg -i "/tmp/$DEB_FILE"
}

rm -f "/tmp/$DEB_FILE"
log "Installation complete!"
log "Run: opencode --version"
