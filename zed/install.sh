#!/bin/sh
#
# Link Zed config into ~/.config/zed (existing files are backed up to *.bak).

set -e
src="$(cd "$(dirname "$0")" && pwd -P)"
dst="$HOME/.config/zed"
mkdir -p "$dst"

for f in settings.json keymap.json tasks.json; do
  if [ "$(readlink "$dst/$f")" = "$src/$f" ]; then continue; fi
  [ -e "$dst/$f" ] && mv "$dst/$f" "$dst/$f.bak"
  ln -s "$src/$f" "$dst/$f"
  echo "› linked $dst/$f"
done
