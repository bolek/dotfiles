# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && [[ -r $HOMEBREW_PREFIX/etc/grc.zsh ]]
then
  source $HOMEBREW_PREFIX/etc/grc.zsh
fi
