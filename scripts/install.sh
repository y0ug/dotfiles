#!/usr/bin/env bash

echo_task() {
  printf "\033[0;34m--> %s\033[0m\n" "$*"
}

error() {
  printf "\033[0;31m%s\033[0m\n" "$*" >&2
  exit 1
}

# -e: exit on error
# -u: exit on unset variables
set -e

if [ -f /etc/debian_version ]; then
  echo_task "ensure required dependencies are installed"

  # Function to add dependency if missing
  install_if_missing() {
    if ! command -v "$1" >/dev/null; then
      sudo apt-get -y install $1
    else
      echo_task "$1 is already installed"
    fi
  }

  # Check and add dependencies
  install_if_missing zsh
  install_if_missing git
  install_if_missing wget
  install_if_missing curl
  sudo chsh -s $(which zsh) $(whoami)
  sudo usermod -s $(which zsh) $(whoami)
fi

# Install Chezmoi if not already installed
if ! chezmoi="$(command -v chezmoi)"; then
  bin_dir="${HOME}/.local/bin"
  mkdir -p ${bin_dir}
  chezmoi="${bin_dir}/chezmoi"
  echo_task "Installing chezmoi to ${chezmoi}"
  if command -v curl >/dev/null; then
    chezmoi_installer="$(curl -fsSL https://git.io/chezmoi)"
  elif command -v wget >/dev/null; then
    chezmoi_installer="$(wget -qO- https://git.io/chezmoi)"
  else
    error "To install chezmoi, you must have curl or wget."
  fi
  sh -c "${chezmoi_installer}" -- -b "${bin_dir}"
  unset chezmoi_installer bin_dir
fi

chezmoi_args="--exclude=encrypted"
chezmoi_init_args=""

if [ -n "${DOTFILES_DEBUG:-}" ]; then
  chezmoi_args="${chezmoi_args} --debug"
fi

if [ -n "${DOTFILES_VERBOSE:-}" ]; then
  chezmoi_args="${chezmoi_args} --verbose"
fi

if [ -n "${DOTFILES_NO_TTY:-}" ]; then
  chezmoi_args="${chezmoi_args} --no-tty"
fi

if [ -n "${DOTFILES_BRANCH:-}" ]; then
  echo_task "Chezmoi branch: ${DOTFILES_BRANCH}"
  chezmoi_init_args="${chezmoi_init_args} --branch ${DOTFILES_BRANCH}"
fi

# If DOTFILES_REPOSITORY is not set, we init from the main twitchel/dotfiles repository
if [ -n "${DOTFILES_REPOSITORY:-}" ]; then
  echo_task "Chezmoi repo: ${DOTFILES_REPOSITORY}"
  chezmoi_init_args="${chezmoi_init_args} ${DOTFILES_REPOSITORY}"
else
  echo_task "Chezmoi default repo: y0ug/dotfiles"
  chezmoi_init_args="${chezmoi_init_args} y0ug/dotfiles"
fi

echo_task "Running chezmoi init"
"${chezmoi}" init ${chezmoi_init_args} ${chezmoi_args}

echo_task "Running chezmoi update"
"${chezmoi}" update ${chezmoi_args}
