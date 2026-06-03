#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?version required}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/common.sh"

STAGED_PREFIX="$ROOT_DIR/artifacts/staged/prefix"
DEB_ROOT="$ROOT_DIR/packaging/deb/work"
OUT_DIR="$ROOT_DIR/packaging/deb"
PREFIX="/data/data/com.termux/files/usr"
ARCH="aarch64"
MAINTAINER="opencode-termux-auto <auto-build@users.noreply.github.com>"

[[ -x "$STAGED_PREFIX/bin/opencode" ]] || fail "missing staged launcher"

rm -rf "$DEB_ROOT"
mkdir -p "$DEB_ROOT/DEBIAN" "$DEB_ROOT$PREFIX" "$OUT_DIR"
chmod 755 "$DEB_ROOT" "$DEB_ROOT/DEBIAN"
cp -a "$STAGED_PREFIX/." "$DEB_ROOT$PREFIX/"

cat >"$DEB_ROOT/DEBIAN/control" <<EOF
Package: opencode
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Section: utils
Priority: optional
Description: OpenCode AI coding assistant for Termux (auto-build)
Depends: bash, ncurses
EOF

INSTALLED_SIZE=$(du -sk "$DEB_ROOT" | cut -f1)
echo "Installed-Size: $INSTALLED_SIZE" >>"$DEB_ROOT/DEBIAN/control"

cat >"$DEB_ROOT/DEBIAN/postinst" <<'POSTINST'
#!/data/data/com.termux/files/usr/bin/bash
set -e
echo "OpenCode for Termux installed"
echo "Run: opencode --version"
exit 0
POSTINST
chmod 755 "$DEB_ROOT/DEBIAN/postinst"

dpkg-deb --build "$DEB_ROOT" "$OUT_DIR/opencode_${VERSION}_${ARCH}.deb"
log "DEB: $OUT_DIR/opencode_${VERSION}_${ARCH}.deb"