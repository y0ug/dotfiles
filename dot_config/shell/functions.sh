# functions.sh - Shared functions for zsh and bash

bak() {
  local now f
  now=$(date +"%Y%m%d-%H%M%S")
  for f in "$@"; do
    [[ -e "$f" ]] || { echo "file not found: $f" >&2; continue; }
    cp -LR "$f" "$f.$now.bak"
  done
}

mkcd() { mkdir -p "$1" && cd "$1"; }
mkcdt() { cd "$(mktemp -d "$@")"; }
touchf() { mkdir -p "$(dirname "$1")" && touch "$1"; }
cliprun() { eval "$(wl-paste)"; }
fdcat() { fd -t f "$@" -x sh -c 'printf "\n\033[1;34m=== %s ===\033[0m\n" "$1" && cat "$1"' _ {}; }
clone() { git clone "https://github.com/$1.git" "${2:-${1##*/}}"; }

resize() {
  local size="${2:-2048}"
  magick "$1" -resize "${size}x${size}" -strip -quality 85 "resized_$1"
}
