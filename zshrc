[[ -e /etc/profile ]] && emulate bash -c 'source /etc/profile'
[[ -e ~/.profile ]] && emulate bash -c 'source ~/.profile'

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"
ENABLE_CORRECTION="false"

zstyle ':omz:update' mode auto

plugins=(git vi-mode)

# Load OMZ
fpath+="${ZSH_CUSTOM:-"$ZSH/custom"}/plugins/zsh-completions/src"
[[ -e $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

PROMPT='%F{cyan}%n%f@%F{green}%m:%F{yellow}%~%f$ '

if type brew &>/dev/null
then
	fpath+="$(brew --prefix)/share/zsh/site-functions"
fi
