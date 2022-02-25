FILE=~/Library/Application\ Support/Code/User
if ! test -f "$FILE"; then
  ln -s ~/iCloud/Code/User $FILE
fi
