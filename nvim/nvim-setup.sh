#!/bin/bash

if ! command -v node &> /dev/null
then
	echo "installing NVM then node"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
	nvm install node
	npm i -g pyright
fi

if ! python3 -m venv -h &> /dev/null
then
	echo "installing python3 venv"
	python3 -m pip install venv --user
fi

PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
if [[ ! -f ${PLUG_DIR} ]]
then
	curl -fLo ${PLUG_DIR} --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! command -v nvim &> /dev/null
then
	echo "installing nvim"
	if [ -f /etc/lsb-release ]; then
		sudo apt-get install software-properties-common
		sudo add-apt-repository ppa:neovim-ppa/unstable
		sudo apt-get update
		sudo apt-get install neovim
	fi
fi

NVIM_PATH=$(command -v nvim)
mkdir -p ~/.local/bin/
ln -s $NVIM_PATH ~/.local/bin/vim
ln -s $NVIM_PATH ~/.local/bin/editor
ln -s $NVIM_PATH ~/.local/bin/vi
