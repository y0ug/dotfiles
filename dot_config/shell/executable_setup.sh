#!/usr/bin/env bash
# setup.sh - Install/uninstall unified shell config into $HOME
#
# Usage:
#   ./setup.sh install   [zsh|bash|all]
#   ./setup.sh uninstall [zsh|bash|all]

set -euo pipefail

SHELL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_backup() {
  local f="$1"
  if [[ -e "$f" || -L "$f" ]]; then
    local bak="$f.bak.$(date +%Y%m%d-%H%M%S)"
    mv "$f" "$bak"
    echo "  backed up $f -> $bak"
  fi
}

install_zsh() {
  echo "Installing zsh config..."
  _backup "$HOME/.zshenv"
  cat > "$HOME/.zshenv" <<'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell/zsh"
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
EOF
  echo "  wrote ~/.zshenv (ZDOTDIR -> $SHELL_DIR/zsh)"
}

install_bash() {
  echo "Installing bash config..."
  _backup "$HOME/.bash_profile"
  _backup "$HOME/.bashrc"
  cat > "$HOME/.bash_profile" <<'EOF'
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bash/bash_profile"
EOF
  cat > "$HOME/.bashrc" <<'EOF'
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bash/bashrc"
EOF
  echo "  wrote ~/.bash_profile -> $SHELL_DIR/bash/bash_profile"
  echo "  wrote ~/.bashrc -> $SHELL_DIR/bash/bashrc"
}

uninstall_zsh() {
  echo "Uninstalling zsh config..."
  if [[ -f "$HOME/.zshenv" ]]; then
    rm "$HOME/.zshenv"
    echo "  removed ~/.zshenv"
  else
    echo "  ~/.zshenv not found, nothing to do"
  fi
}

uninstall_bash() {
  echo "Uninstalling bash config..."
  local removed=0
  for f in "$HOME/.bash_profile" "$HOME/.bashrc"; do
    if [[ -f "$f" ]]; then
      rm "$f"
      echo "  removed $f"
      removed=1
    fi
  done
  [[ $removed -eq 0 ]] && echo "  nothing to remove"
}

usage() {
  echo "Usage: $0 {install|uninstall} [zsh|bash|all]"
  echo "  Default target: all"
  exit 1
}

action="${1:-}"
target="${2:-all}"

case "$action" in
  install)
    case "$target" in
      zsh)  install_zsh ;;
      bash) install_bash ;;
      all)  install_zsh; install_bash ;;
      *)    usage ;;
    esac
    echo "Done. Test with:"
    [[ "$target" == zsh || "$target" == all ]]  && echo "  zsh:  ZDOTDIR=~/.config/shell/zsh zsh"
    [[ "$target" == bash || "$target" == all ]] && echo "  bash: bash --init-file ~/.config/shell/bash/bash_profile"
    ;;
  uninstall)
    case "$target" in
      zsh)  uninstall_zsh ;;
      bash) uninstall_bash ;;
      all)  uninstall_zsh; uninstall_bash ;;
      *)    usage ;;
    esac
    ;;
  *)
    usage
    ;;
esac
