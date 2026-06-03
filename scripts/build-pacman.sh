#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?version required}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/common.sh"

STAGED_PREFIX="$ROOT_DIR/artifacts/staged/prefix"
PACMAN_DIR="$ROOT_DIR/packaging/pacman"

[[ -x "$STAGED_PREFIX/bin/opencode" ]] || fail "missing staged launcher"

cd "$PACMAN_DIR"
rm -rf pkg src

PACKAGER_NAME="opencode-termux-auto <auto-build@users.noreply.github.com>"
PKGREL="${PKGREL:-1}"

TMP_PKGBUILD="$PACMAN_DIR/.PKGBUILD.tmp"
sed -e "s/^pkgver=.*/pkgver=$VERSION/" -e "s/^pkgrel=.*/pkgrel=$PKGREL/" \
  "$PACMAN_DIR/PKGBUILD" > "$TMP_PKGBUILD"

if command -v makepkg >/dev/null 2>&1; then
  STAGED_PREFIX="$STAGED_PREFIX" REPO_ROOT="$ROOT_DIR" \
    makepkg --noconfirm -f -p "$TMP_PKGBUILD" 2>&1
  log "PACMAN package created"
else
  log "makepkg not available, creating simple tarball"
  mkdir -p "opencode-$VERSION"
  cp -a "$STAGED_PREFIX/." "opencode-$VERSION/"
  tar -cJf "opencode-$VERSION-aarch64.pkg.tar.xz" "opencode-$VERSION"
  rm -rf "opencode-$VERSION"
fi