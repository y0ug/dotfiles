apt update && apt install -yq xz-utils curl sudo
useradd -m -s /bin/bash rick
adduser rick sudo
echo "rick ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/rick
su rick

sh <(curl -L https://nixos.org/nix/install) --no-daemon
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update
nix shell nixpkgs#home-manager --command home-manager switch --flake ~/.config/home-manager/
