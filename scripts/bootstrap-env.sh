#!/bin/sh
MODE=default
[ "${1}" = "public" ] && MODE=${1}
[ "${1}" = "private" ] && MODE=${1}

if [ "${MODE}" = "default" ] && [ -n "$(grep rick@levua "${HOME}/.ssh/id_rsa.pub" 2>/dev/null)" ]; then
	MODE="private"
else
	MODE="public"
fi

echo "Mode: ${MODE}"

if [ -f /etc/alpine-release ]; then
	echo "[*] Alpine"
	doas apk add vim curl git
elif [ -f /etc/lsb-release ] && grep -qi "DISTRIB_ID=ubuntu" /etc/lsb-release; then
	echo "[*] Ubuntu"
	sudo apt install curl git vim -y
elif [ -f /etc/os-release ] && grep -qi "ID=debian" /etc/os-release; then
	echo "[*] Debian"
	sudo apt install curl git vim -y
elif [ "$(uname)" = "Darwin" ]; then
	echo "[*] OSX"
	#brew install
else
	echo "[*] Unsupported OS"
	exit 1
fi

if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	echo "[*] WSL detected"
	[ ! -e /usr/bin/keychain ] && sudo apt install keychain -y
	[ -z $SSH_AUTH_SOCK ] && eval $(keychain --eval --agents ssh id_rsa)
	[ ! -e /usr/bin/zsh ] && sudo apt install zsh -y
fi

mkdir -p ${HOME}/.local/bin

GIT_REPO_PREFIX="https://github.com/y0ug"

if [ "$MODE" = "private" ]; then
	GIT_REPO_PREFIX="git@github.com:y0ug"

	if [ ! -e ${HOME}/scripts ]; then
		git clone ${GIT_REPO_PREFIX}/scripts.git ${HOME}/scripts
	fi

	if [ ! -e ${HOME}/.dotfiles-private ]; then
		git clone ${GIT_REPO_PREFIX}/dotfiles-private.git ${HOME}/.dotfiles-private
	fi
	# Avoid override if exist, should check if http_proxy exist
	if [ ! -e ${HOME}/.ssh/config ]; then
		ln -fs ${HOME}/.dotfiles-private/ssh/config ${HOME}/.ssh/config
	fi
fi

if [ ! -e ${HOME}/.dotfiles ]; then
	git clone ${GIT_REPO_PREFIX}/dotfiles.git ${HOME}/.dotfiles
fi

if [ ! -e ${HOME}/.vim/autoload/plug.vim ]; then
	curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -e ${HOME}/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
fi

if [ -e /usr/bin/zsh ]; then
	${HOME}/.dotfiles/scripts/zsh-setup.sh
fi

ln -fs ${HOME}/.dotfiles/tmux.conf ${HOME}/.tmux.conf
ln -fs ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
ln -fs ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc

git config --global user.email "hca443@gmail.com"
git config --global user.name "Hugo Caron"

if [ -z "$(grep EDITOR ${HOME}/.profile)" ]; then
	echo "EDITOR=vim" >>${HOME}/.profile
fi
