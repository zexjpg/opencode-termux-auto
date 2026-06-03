#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

REPO="zexjpg/opencode-termux-auto"
VERSION="${1:-latest}"
TMP="${TMPDIR:-${PREFIX:-/data/data/com.termux/files/usr}/tmp}"

log()  { printf '\033[1;32m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[install]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[install]\033[0m %s\n' "$*" >&2; exit 1; }

command -v dpkg >/dev/null 2>&1 || die "dpkg not found. Are you on Termux?"
command -v curl >/dev/null 2>&1 || die "curl not found. Install: apt install curl"

if [ "$(uname -m)" != "aarch64" ]; then
  die "Only aarch64 is supported. Detected: $(uname -m)"
fi

log "Installing OpenCode for Termux..."

if [ "$VERSION" = "latest" ]; then
  log "Fetching latest version from GitHub..."
  VERSION=$(curl -sSL "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep -o '"tag_name":"[^"]*"' | cut -d'"' -f4 || true)
  VERSION="${VERSION#v}"
  if [ -z "$VERSION" ]; then
    log "GitHub API unavailable, trying fallback..."
    VERSION=$(curl -sSL "https://github.com/$REPO/releases" 2>/dev/null | grep -o '/releases/tag/v[0-9.]*' | head -1 | grep -o '[0-9].*' || true)
  fi
  if [ -z "$VERSION" ]; then
    die "Failed to detect latest version. Specify manually: install-opencode.sh 1.15.13"
  fi
  log "Latest version: $VERSION"
fi

VERSION="${VERSION#v}"
log "Checking dependencies..."

apt install -y glibc-repo >/dev/null 2>&1 || true
apt update >/dev/null 2>&1 || true
apt install -y glibc openssl-glibc >/dev/null 2>&1 || {
  warn "Dependency install had issues, continuing..."
}

log "Dependencies ready."

DEB_URL="https://github.com/$REPO/releases/download/v$VERSION/opencode_${VERSION}_aarch64.deb"
DEB_FILE="$TMP/opencode_${VERSION}_aarch64.deb"

log "Downloading $DEB_FILE ..."
curl -fL -o "$DEB_FILE" "$DEB_URL" || die "Download failed.\n  URL: $DEB_URL\n  Check version or network."

log "Installing..."
dpkg -i "$DEB_FILE" || {
  warn "Fixing dependencies..."
  apt install -f -y >/dev/null 2>&1 || true
  dpkg -i "$DEB_FILE"
}

rm -f "$DEB_FILE"
log "Installation complete!"
log "Run: opencode --version"
