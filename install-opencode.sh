#!/data/data/com.termux/files/usr/bin/bash
# Install OpenCode for Termux from zexjpg/opencode-termux-auto

REPO="zexjpg/opencode-termux-auto"
VERSION="${1:-latest}"
TMP="${TMPDIR:-$PREFIX/tmp}"

G='\033[1;32m'; R='\033[1;31m'; N='\033[0m'
log() { printf "${G}[install]${N} %s\n" "$*"; }
die() { printf "${R}[install]${N} %s\n" "$*" >&2; exit 1; }

command -v dpkg >/dev/null 2>&1 || die "dpkg required (are you on Termux?)"
command -v curl >/dev/null 2>&1 || die "curl required (apt install curl)"

if [ "$VERSION" = "latest" ]; then
  log "Detecting latest version..."
  VERSION=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -o '"tag_name":"[^"]*"' | cut -d'"' -f4)
  VERSION="${VERSION#v}"
  [ -n "$VERSION" ] || die "Version detection failed. Usage: install-opencode.sh 1.15.13"
  log "Latest: $VERSION"
fi

log "Installing dependencies..."
apt install -y glibc-repo >/dev/null 2>&1
apt update >/dev/null 2>&1 || true
apt install -y glibc openssl-glibc >/dev/null 2>&1 || true

DEB="opencode_${VERSION}_aarch64.deb"
URL="https://github.com/$REPO/releases/download/v$VERSION/$DEB"
log "Downloading $DEB ..."
curl -fL -o "$TMP/$DEB" "$URL" || die "Download failed: $URL"

log "Installing..."
dpkg -i "$TMP/$DEB" || { apt install -f -y && dpkg -i "$TMP/$DEB"; }
rm -f "$TMP/$DEB"

log "Done! Run: opencode --version"