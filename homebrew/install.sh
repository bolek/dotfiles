#!/bin/sh
#
# Install Homebrew if it's missing.

if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]
then
  echo "  Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

exit 0
