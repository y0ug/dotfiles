#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# single character aliases - be sparing!
alias _=sudo
alias l=ls
alias g=git

# mask built-ins with better defaults
alias vi=vim

# more ways to ls
alias ll='ls -lh'
alias la='ls -lAh'
alias ldot='ls -ld .*'

if command -v exa >/dev/null 2>&1; then
  alias eza="exa --group-directories-first --hyperlink --icons=auto"
  alias exa="exa --group-directories-first --hyperlink --icons=auto"
  alias ls="exa"
  alias ll="exa -l -g --time-style=long-iso"
  alias l="exa -F -a"
  alias la="exa -aa"
fi

# fix common typos
alias quit='exit'
alias cd..='cd ..'

# tar
alias tarls="tar -tvf"
alias untar="tar -xf"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias pbcopy='xclip -selection clipboard'
alias pbcopy='wl-copy'
alias pbpaste='xclip -selection clipboard -o'
alias pbpaste='wl-paste'

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# misc
alias please=sudo
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zbench='for i in {1..10}; do /usr/bin/env time zsh -lic exit; done'
alias zdot='cd ${ZDOTDIR:-~}'

(($+commands[nvim])) && alias vim=nvim


# Check and set pbcopy/pbpaste aliases based on available tools
if command -v pbcopy >/dev/null 2>&1; then
    # macOS already has pbcopy/pbpaste
    :
elif command -v xclip >/dev/null 2>&1; then
    # Use xclip if available
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
elif command -v wl-copy >/dev/null 2>&1; then
    # Use Wayland clipboard if available
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
elif [[ "$TERM" == *"xterm"* ]] || [[ "$TERM" == *"screen"* ]] || [[ -n "$TMUX" ]]; then
    # Use OSC 52 escape sequence for terminals that support it
    function pbcopy() {
        local data=$(cat)
        printf "\033]52;c;$(printf "%s" "$data" | base64)\a"
    }
    function pbpaste() {
        echo "pbpaste via OSC is not supported directly - clipboard data can only be sent TO terminal"
    }
else
    # Fallback message if no clipboard tool is available
    function pbcopy() {
        echo "No clipboard tool available"
        return 1
    }
    function pbpaste() {
        echo "No clipboard tool available"
        return 1
    }
fi
