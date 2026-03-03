# aliases.sh - Shared aliases for zsh and bash

# Core
alias _=sudo
alias g=git
alias v=nvim vi=nvim vim=nvim
alias l=ls
alias t=tmux
alias lg=lazygit
alias xdg-open="openit open --no-open-with --terminal-mode=current"
alias o=xdg-open
alias cr=cliprun

# Git
alias gs="git status"
alias ga="git add"
alias gp="git pull"
alias gpa="git pull --all"
alias gP="git push"
alias gPb='git push origin $(git branch --show-current)'

# Files
alias tp="trash-put"
alias ll='ls -lh'
alias la='ls -lAh'
alias ldot='ls -ld .*'
if command -v eza &>/dev/null; then
  alias eza="eza --group-directories-first"
  alias ls="eza --group-directories-first"
  alias ll="eza -l -g --time-style=long-iso"
  alias l="eza -F -a"
  alias la="eza -aa"
  alias llar="\eza -la --sort=modified"
  alias tree="eza -T --group-directories-first --git-ignore"
  alias lastdl="\eza -1 --absolute --sort modified ~/Downloads | tr -d \"'\""
fi

# Search
alias rgv="rg --pretty --vimgrep -H"
alias fdf='fd -type f -name'
alias fdd='fd -type d -name'

# Shortcuts
alias quit=exit
alias cd..='cd ..'

# Archives
alias tarls="tar -tvf"
alias untar="tar -xf"

# URL encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

# Secrets
alias gen-token='python3 -c "import secrets; print(secrets.token_urlsafe(32))"'
alias gen-pwd='bw generate -nuls --length 16 --ambiguous'

# Certificates
alias certpem='f(){ openssl s_client -connect "$1" -servername "${2:-${1%:*}}" </dev/null 2>/dev/null | openssl x509; }; f'
alias certinfo='openssl x509 -noout -subject -issuer -dates -fingerprint -sha256'
alias certdump='openssl x509 -noout -text'

# Media
alias rip="yt-dlp -x --audio-format=mp3"

# Dev
alias nokey='env -u ANTHROPIC_API_KEY -u CLAUDE_API_KEY'
alias nvim-mini='nvim -u ~/.config/nvim-mini/init.lua'
alias venv="source .venv/bin/activate"
