FILE=~/iCloud
if ! test -f "$FILE"; then
  ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs $FILE
fi
