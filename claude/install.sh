#!/bin/sh
#
# Claude: desktop app, Claude Code CLI, and ~/.claude/settings.json.
#
# Settings are layered (later wins):
#   claude/settings.json                         shared defaults (this repo)
#   profiles/$DOTFILES_PROFILE/claude/settings.json
#   $DOTFILES_PRIVATE/claude/settings.json       private, e.g. work autoMode
#   ~/.claude/settings.json                      whatever is already there
# so re-running never clobbers changes made from inside Claude Code.

set -e
cd "$(dirname "$0")/.."
# shellcheck disable=SC1090
[ -f ~/.localrc ] && . ~/.localrc
DOTFILES_PRIVATE=${DOTFILES_PRIVATE:-$HOME/.dotfiles-private}

if [ ! -d /Applications/Claude.app ]; then
  echo "› installing Claude desktop"
  brew install --cask claude
fi

# Native installer (auto-updates; installs to ~/.local/bin/claude)
if ! command -v claude >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/claude" ]; then
  echo "› installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

mkdir -p ~/.claude
target=~/.claude/settings.json
layers="claude/settings.json"
for f in "profiles/$DOTFILES_PROFILE/claude/settings.json" "$DOTFILES_PRIVATE/claude/settings.json" "$target"; do
  [ -f "$f" ] && layers="$layers $f"
done

tmp=$(mktemp)
# shellcheck disable=SC2086
jq -s 'reduce .[] as $x ({}; . * $x)' $layers > "$tmp"
if [ -f "$target" ] && cmp -s "$tmp" "$target"; then
  rm -f "$tmp"
else
  [ -f "$target" ] && cp "$target" "$target.bak"
  mv "$tmp" "$target"
  echo "› wrote $target"
fi
