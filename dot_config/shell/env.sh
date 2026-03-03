# env.sh - Shared environment: XDG, editors, pagers

# XDG base directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/repo}

# Editors and pagers
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export PAGER=nvimpager

# macOS quirk
[[ "$OSTYPE" == darwin* ]] && export SHELL_SESSIONS_DISABLE=1

# Source external env files
[[ -e "$HOME/.profile" ]] && source "$HOME/.profile"
[[ -e "$HOME/.local/share/bob/env/env.sh" ]] && source "$HOME/.local/share/bob/env/env.sh"
[[ -e "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
