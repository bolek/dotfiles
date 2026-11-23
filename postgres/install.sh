#!/bin/sh
#
# pgenv (https://github.com/theory/pgenv): Postgres version manager. No
# Homebrew formula, so it's a git checkout in ~/.pgenv (on PATH via _path.zsh).

set -e
cd "$(dirname "$0")"
PGENV_ROOT="$HOME/.pgenv"

if [ ! -d "$PGENV_ROOT/.git" ]; then
  echo "› installing pgenv"
  git clone -q https://github.com/theory/pgenv.git "$PGENV_ROOT"
else
  git -C "$PGENV_ROOT" pull -q --ff-only || echo "  ! could not update pgenv"
fi

if [ ! -f "$PGENV_ROOT/config/default.conf" ]; then
  mkdir -p "$PGENV_ROOT/config"
  cp pgenv-default.conf "$PGENV_ROOT/config/default.conf"
  echo "› seeded $PGENV_ROOT/config/default.conf"
fi
