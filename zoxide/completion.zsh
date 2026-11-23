# zoxide: smarter cd. `z foo` jumps to the best-ranked dir matching "foo",
# `zi` picks interactively with fzf. https://github.com/ajeetdsouza/zoxide
#
# Named completion.zsh so it loads after compinit; zoxide only registers its
# tab completion for `z` when compdef already exists.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
