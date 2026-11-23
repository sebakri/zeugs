#!/bin/sh
# Installs zeugs apps from their GitHub releases into /Applications/zeugs.
# Usage: curl -fsSL https://sebakri.github.io/zeugs/install.sh | sh -s -- draw
#        curl -fsSL https://sebakri.github.io/zeugs/install.sh | sh -s -- all
# Set ZEUGS_VERSION to install a specific version of one app.
# Set ZEUGS_DEST to change the target folder.
set -eu

REPO="sebakri/zeugs"
APPS="draw note pdf sweep table"
DEST="${ZEUGS_DEST:-/Applications/zeugs}"
ARG="${1:-}"

[ "$(uname -s)" = Darwin ] || { echo "The zeugs apps are for macOS." >&2; exit 1; }

install_app() {
  app="$1"
  case "$app" in
    draw) name=Draw ;;
    note) name=Note ;;
    pdf) name=Pdf ;;
    table) name=Table ;;
    sweep) name=Sweep ;;
  esac

  version="${ZEUGS_VERSION:-}"
  if [ -z "$version" ]; then
    # The API lists releases newest first.
    version="$(curl -fsSL "https://api.github.com/repos/$REPO/releases?per_page=100" \
      | grep -o "\"tag_name\": *\"$app-v[0-9][0-9.]*\"" | head -n 1 \
      | sed "s/.*$app-v//; s/\"//")" || version=""
  fi
  if [ -z "$version" ]; then
    echo "No release for $app yet."
    [ "$ARG" = all ] && return 0
    return 1
  fi

  file="${name}_${version}_universal.dmg"
  base="https://github.com/$REPO/releases/download/$app-v$version"
  work="$(mktemp -d)"
  mount="$work/mount"
  trap 'hdiutil detach -quiet "$mount" 2>/dev/null || true; rm -rf "$work"' EXIT INT TERM

  echo "Downloading $file"
  curl -fSL --progress-bar -o "$work/$file" "$base/$file"
  curl -fsSL -o "$work/$file.sha256" "$base/$file.sha256"

  expected="$(awk '{print $1}' "$work/$file.sha256")"
  actual="$(shasum -a 256 "$work/$file" | awk '{print $1}')"
  if [ -z "$expected" ] || [ "$expected" != "$actual" ]; then
    echo "The checksum of $file does not match. Nothing was installed." >&2
    return 1
  fi

  mkdir -p "$mount" "$DEST"
  hdiutil attach -readonly -nobrowse -quiet -mountpoint "$mount" "$work/$file"
  bundle="$(find "$mount" -maxdepth 1 -name '*.app' | head -n 1)"
  [ -n "$bundle" ] || { echo "The disk image has no app." >&2; return 1; }

  target="$DEST/$(basename "$bundle")"
  rm -rf "$target"
  cp -R "$bundle" "$target"
  # The apps are signed ad hoc and not notarized. Without the quarantine flag macOS opens them.
  xattr -cr "$target"
  echo "Installed $target"
}

case "$ARG" in
  all) LIST="$APPS" ;;
  draw|note|pdf|sweep|table) LIST="$ARG" ;;
  *) echo "Usage: install.sh <all|draw|note|pdf|sweep|table>" >&2; exit 2 ;;
esac

# Give the folder the zeugs icon. This is cosmetic, so a failure is ignored.
set_folder_icon() {
  tmp="$(mktemp -d)"
  if curl -fsSL -o "$tmp/zeugs.png" "https://sebakri.github.io/zeugs/assets/zeugs.png"; then
    ICON="$tmp/zeugs.png" FOLDER="$DEST" osascript -l JavaScript -e 'ObjC.import("AppKit"); const e = $.NSProcessInfo.processInfo.environment; const img = $.NSImage.alloc.initWithContentsOfFile(e.objectForKey("ICON")); $.NSWorkspace.sharedWorkspace.setIconForFileOptions(img, e.objectForKey("FOLDER"), 0)' >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp"
}

status=0
for app in $LIST; do
  # A subshell keeps the cleanup trap of each app separate.
  ( install_app "$app" ) || status=1
done
[ -d "$DEST" ] && set_folder_icon
exit $status
