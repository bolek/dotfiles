#!/bin/sh
FILE=~/iCloud
if ! test -e "$FILE" && ! test -L "$FILE"; then
  ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs $FILE
fi
