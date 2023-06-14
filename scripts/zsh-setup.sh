#!/bin/sh
set -e

if [ "$SHELL" = "/bin/ash" ]; then
  echo "[*] this script doesn't work inside ash" >&2
  exit 1
fi

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"

CHSH=${CHSH:-yes}
KEEP_ZSHRC=${KEEP_ZSHRC:-yes}

# OhMyZsh install script
omz_setup="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# Plugins repository
repos=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-completions"
  "https://github.com/zsh-users/zsh-history-substring-search"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
)


# Check if the OS is Alpine
if [ -f /etc/alpine-release ]; then
	echo "[*] Alpine"
	doas apk add curl zsh git
elif [ -f /etc/lsb-release ] && grep -qi "DISTRIB_ID=ubuntu" /etc/lsb-release; then
	echo "[*] Ubuntu"
	sudo apt install curl zsh git
elif [ -f /etc/os-release ] && grep -qi "ID=debian" /etc/os-release; then
	echo "[*] Debian"
	sudo apt install curl zsh git
elif [ "$(uname)" == "Darwin" ]; then
	echo "[*] OSX"
else
	echo "[*] Unsupported OS"
	exit 1
fi

if [ ! -d ${HOME}/.oh-my-zsh/ ]; then
	RUNZSH=no sh -c "$(curl -fsSL ${omz_setup})" --unattended
else
	echo "[*] Updating OhMyZsh"
	zsh ${HOME}/.oh-my-zsh/tools/upgrade.sh
fi

for repo in "${repos[@]}"; do
	repo_name=$(basename "$repo")
  base_dest="${HOME}/.oh-my-zsh/custom/plugins"
  repo_dest="${base_dest}/${repo_name}"
	if [ -d "${repo_dest}" ]; then
    echo "[*] Updating: $repo_name"
    cd "$repo_dest" && git pull
  else
    echo "[*] Cloning $repo_name"
    git clone "$repo" "$repo_dest"
  fi 
done

