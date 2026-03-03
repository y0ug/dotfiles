#!/usr/bin/env bash
# bundle.sh - Generate a self-extracting shell config installer to stdout
#
# Usage:
#   ./bundle.sh > install.sh        # save to file
#   ./bundle.sh | bash -s -- all    # pipe and run locally

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

archive=$(tar -C "$SCRIPT_DIR" -czf - \
  --exclude='bundle.sh' \
  --exclude='deploy.sh' \
  --exclude='.git' \
  --exclude='.claude' \
  . | base64)

cat <<'HEADER'
#!/usr/bin/env bash
set -euo pipefail

target="${1:-all}"
SHELL_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
mkdir -p "$SHELL_DIR"

# --- Install dependencies ---
_install_deps() {
  # tool -> apt package -> brew package
  local -A apt_pkg=(
    [rg]=ripgrep  [eza]=eza     [fd]=fd-find
    [fzf]=fzf     [tmux]=tmux   [zoxide]=zoxide
    [direnv]=direnv [nvim]=neovim [keychain]=keychain
  )
  local -A brew_pkg=(
    [rg]=ripgrep  [eza]=eza     [fd]=fd
    [fzf]=fzf     [tmux]=tmux   [zoxide]=zoxide
    [direnv]=direnv [nvim]=neovim [starship]=starship
  )

  local is_wsl=0
  [[ -f /proc/version ]] && grep -qi microsoft /proc/version && is_wsl=1

  # check what is missing
  local missing=()
  for cmd in rg eza fd fzf tmux zoxide direnv nvim keychain starship; do
    # keychain only on WSL
    [[ "$cmd" == keychain && $is_wsl -eq 0 ]] && continue
    command -v "$cmd" &>/dev/null && continue
    # fd has an alternate name on debian
    [[ "$cmd" == fd ]] && command -v fdfind &>/dev/null && continue
    missing+=("$cmd")
  done

  [[ ${#missing[@]} -eq 0 ]] && return 0

  if command -v apt-get &>/dev/null; then
    local pkgs=()
    for cmd in "${missing[@]}"; do
      [[ -n "${apt_pkg[$cmd]:-}" ]] && pkgs+=("${apt_pkg[$cmd]}")
    done
    if [[ ${#pkgs[@]} -gt 0 ]]; then
      echo "Installing packages (apt): ${pkgs[*]} ..."
      if [[ $(id -u) -eq 0 ]]; then
        apt-get update -qq && apt-get install -y -qq "${pkgs[@]}" || true
      elif command -v sudo &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y -qq "${pkgs[@]}" || true
      else
        echo "  No root access, skipping: ${pkgs[*]}"
      fi
    fi

    # fd-find installs as fdfind; symlink so scripts can use 'fd'
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
      mkdir -p "$HOME/.local/bin"
      ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
      echo "  Linked fdfind -> ~/.local/bin/fd"
    fi

    # starship is not in apt; use official installer
    if ! command -v starship &>/dev/null; then
      echo "Installing starship via official installer ..."
      curl -sS https://starship.rs/install.sh | sh -s -- -y 2>/dev/null || true
    fi

  elif command -v brew &>/dev/null; then
    local pkgs=()
    for cmd in "${missing[@]}"; do
      [[ -n "${brew_pkg[$cmd]:-}" ]] && pkgs+=("${brew_pkg[$cmd]}")
    done
    if [[ ${#pkgs[@]} -gt 0 ]]; then
      echo "Installing packages (brew): ${pkgs[*]} ..."
      brew install "${pkgs[@]}"
    fi

  else
    echo "No supported package manager found, skipping: ${missing[*]}"
  fi
}

_install_deps

echo "Extracting shell config to $SHELL_DIR ..."
base64 -d <<'__ARCHIVE__' | tar -C "$SHELL_DIR" -xzf -
HEADER

printf '%s\n' "$archive"

cat <<'FOOTER'
__ARCHIVE__

chmod +x "$SHELL_DIR/setup.sh"
"$SHELL_DIR/setup.sh" install "$target"
FOOTER
