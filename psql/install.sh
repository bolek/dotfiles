#!/bin/sh
#
# psql keeps per-host history in ~/.psql (see psqlrc.symlink); it doesn't
# create the directory and silently drops history without it.

mkdir -p "$HOME/.psql"
