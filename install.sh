#!/bin/sh
# Installs a zeugs app from its GitHub release.
# Usage: curl -fsSL https://sebakri.github.io/zeugs/install.sh | sh -s -- draw
# Set ZEUGS_VERSION to install a specific version. Set ZEUGS_DEST to change the target folder.
set -eu

REPO="sebakri/zeugs"
APP="${1:-}"
DEST="${ZEUGS_DEST:-/Applications}"

case "$APP" in
  draw) NAME=Draw ;;
  note) NAME=Note ;;
  pdf) NAME=Pdf ;;
  table) NAME=Table ;;
  sweep) NAME=Sweep ;;
  *) echo "Usage: install.sh <draw|note|pdf|table|sweep>" >&2; exit 2 ;;
esac

[ "$(uname -s)" = Darwin ] || { echo "The zeugs apps are for macOS." >&2; exit 1; }

VERSION="${ZEUGS_VERSION:-}"
if [ -z "$VERSION" ]; then
  # The API lists releases newest first.
  VERSION="$(curl -fsSL "https://api.github.com/repos/$REPO/releases?per_page=100" \
    | grep -o "\"tag_name\": *\"$APP-v[0-9][0-9.]*\"" | head -n 1 \
    | sed "s/.*$APP-v//; s/\"//")"
fi
[ -n "$VERSION" ] || { echo "No release found for $APP." >&2; exit 1; }

FILE="${NAME}_${VERSION}_universal.dmg"
BASE="https://github.com/$REPO/releases/download/$APP-v$VERSION"
WORK="$(mktemp -d)"
MOUNT="$WORK/mount"
cleanup() {
  hdiutil detach -quiet "$MOUNT" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT INT TERM

echo "Downloading $FILE"
curl -fSL --progress-bar -o "$WORK/$FILE" "$BASE/$FILE"
curl -fsSL -o "$WORK/$FILE.sha256" "$BASE/$FILE.sha256"

EXPECTED="$(awk '{print $1}' "$WORK/$FILE.sha256")"
ACTUAL="$(shasum -a 256 "$WORK/$FILE" | awk '{print $1}')"
if [ -z "$EXPECTED" ] || [ "$EXPECTED" != "$ACTUAL" ]; then
  echo "The checksum does not match. Nothing was installed." >&2
  exit 1
fi
echo "Checksum ok"

mkdir -p "$MOUNT"
hdiutil attach -readonly -nobrowse -quiet -mountpoint "$MOUNT" "$WORK/$FILE"
BUNDLE="$(find "$MOUNT" -maxdepth 1 -name '*.app' | head -n 1)"
[ -n "$BUNDLE" ] || { echo "The disk image has no app." >&2; exit 1; }

TARGET="$DEST/$(basename "$BUNDLE")"
rm -rf "$TARGET"
cp -R "$BUNDLE" "$TARGET"
# The apps are signed ad hoc and not notarized. Without the quarantine flag macOS opens them.
xattr -cr "$TARGET"
echo "Installed $TARGET"
