export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"
ENABLE_CORRECTION="false"

zstyle ':omz:update' mode auto

# User configuration
# Hack to load the profile
[[ -e /etc/profile ]] && emulate sh -c 'source /etc/profile'
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# OSx doesn't have .profile that set the local bin
local_bin="${HOME}/.local/bin"
[[ ":$PATH:" != *":$local_bin:"* ]] && [[ -d $local_bin ]] && PATH="$local_bin:$PATH"

# zsh-autosuggestions
# zsh-syntax-highlighting
plugins=(git
  #history-substring-search
  zsh-vi-mode
  )

# Load OMZ
fpath+="${ZSH_CUSTOM:-"$ZSH/custom"}/plugins/zsh-completions/src"

[[ -e $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

PROMPT='%F{cyan}%n%f@%F{green}%m:%F{yellow}%~%f$ '
