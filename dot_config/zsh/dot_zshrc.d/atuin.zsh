# if command -v atuin &>/dev/null; then
#   eval "$(atuin init zsh)"
# fi
(( $+commands[atuin] )) || return 1
eval "$(atuin init zsh)"
