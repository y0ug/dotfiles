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

# Metadata helpers: back up each input before modifying it.
_metadata_backup() {
  [[ -f "$1" && ! -L "$1" ]] || {
    printf 'Expected a regular file (not a symlink): %s\n' "$1" >&2
    return 1
  }
  # noclobber prevents overwriting an existing backup, including a symlink.
  (set -C; cat -- "$1" > "$1.bak") || return 1
  printf 'Backup created: %s.bak\n' "$1"
}

clear_exif() {
  [[ $# -gt 0 ]] || { printf 'Usage: clear_exif FILE...\n' >&2; return 1; }
  command -v exiftool >/dev/null || { printf 'Missing command: exiftool\n' >&2; return 1; }
  local file
  for file in "$@"; do
    _metadata_backup "$file" || return 1
    command exiftool -all= -overwrite_original -- "$file" || return 1
  done
}

# Shared PDF processing. Work on a copy and replace the input only on success.
_metadata_pdf() (
  local mode="$1" file tool workdir='' input
  shift
  [[ $# -gt 0 ]] || { printf 'Usage: %s FILE.pdf...\n' "$mode" >&2; return 1; }
  for tool in exiftool qpdf; do
    command -v "$tool" >/dev/null || { printf 'Missing command: %s\n' "$tool" >&2; return 1; }
  done
  if [[ "$mode" == flatten_pdf ]]; then
    for tool in pdftoppm img2pdf; do
      command -v "$tool" >/dev/null || { printf 'Missing command: %s\n' "$tool" >&2; return 1; }
    done
  fi
  trap 'if [[ -n "$workdir" ]]; then command rm -rf -- "$workdir"; fi' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  for file in "$@"; do
    # Prefix relative paths so leading dashes cannot be interpreted as options.
    case "$file" in /*) ;; *) file="./$file" ;; esac
    _metadata_backup "$file" || return 1
    workdir=$(mktemp -d "${file}.clean.XXXXXX") || return 1
    command cp -p -- "$file" "$workdir/input.pdf" || return 1
    input="$workdir/input.pdf"
    if [[ "$mode" == flatten_pdf ]]; then
      command pdftoppm -r 300 -png "$input" "$workdir/page" || return 1
      # pdftoppm pads page numbers, so glob order preserves page order.
      command img2pdf "$workdir"/page-*.png -o "$workdir/rebuilt.pdf" || return 1
      input="$workdir/rebuilt.pdf"
    fi
    command exiftool -overwrite_original -all= -- "$input" || return 1
    command qpdf --linearize --remove-unreferenced-resources=yes \
      "$input" "$workdir/clean.pdf" || return 1
    # Retain the input's permissions before replacing it on the same filesystem.
    command chmod --reference="$file" "$workdir/clean.pdf" || return 1
    command mv -f -- "$workdir/clean.pdf" "$file" || return 1
    printf 'Cleaned: %s\n' "$file"
    command rm -rf -- "$workdir" || return 1
    workdir=''
  done
)

# Keep text, vectors, and links; remove writable PDF metadata and old revisions.
clear_pdf() { _metadata_pdf clear_pdf "$@"; }

# Rebuild visible pages as 300 DPI images; removes text, links, and attachments.
flatten_pdf() { _metadata_pdf flatten_pdf "$@"; }
