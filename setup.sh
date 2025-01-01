apt update && apt install -yq xz-utils curl sudo wget git jq
useradd -m -s /bin/bash rick
adduser rick sudo
echo "rick ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/rick
su rick

# Create ~/.local/bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Reload profile
source ~/.profile

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.profile
  echo "Added ~/.local/bin to PATH in .profile"
else
  echo "~/.local/bin is already in PATH"
fi

source ~/.profile

sh <(curl -L https://nixos.org/nix/install) --no-daemon
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update

CHEZMOI_MODE=home
sh -c "$(curl -fsLS https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh)"
nix shell nixpkgs#home-manager --command home-manager switch --flake ~/.config/home-manager/
