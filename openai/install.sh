#!/bin/sh
#
# OpenAI: ChatGPT desktop app, Codex CLI, and a starter ~/.codex/config.toml.

set -e
cd "$(dirname "$0")"

if [ ! -d /Applications/ChatGPT.app ]; then
  echo "› installing ChatGPT desktop"
  brew install --cask chatgpt
fi

if ! command -v codex >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/codex" ]; then
  echo "› installing Codex CLI"
  brew install --cask codex
fi

if [ ! -f ~/.codex/config.toml ]; then
  mkdir -p ~/.codex
  cp codex-config.toml ~/.codex/config.toml
  echo "› seeded ~/.codex/config.toml"
fi
