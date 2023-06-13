export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"
ENABLE_CORRECTION="true"

zstyle ':omz:update' mode auto

# User configuration
# Hack to load the profile
[[ -e /etc/profile ]] && emulate sh -c 'source /etc/profile'
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

plugins=(git
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  )

# Load OMZ
fpath+="${ZSH_CUSTOM:-"$ZSH/custom"}/plugins/zsh-completions/src"

[[ -e $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

