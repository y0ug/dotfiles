# (( $+commands[zoxide] )) || return 1
# eval "$(zoxide init zsh)"


if (($+commands[zoxide])); then
  eval "$(zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh)"
fi
