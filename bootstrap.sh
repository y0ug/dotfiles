export PATH=$HOME/.local/bin:$PATH
apt update && apt install sudo curl wget git jq
CHEZMOI_MODE=home
sh -c "$(curl -fsLS https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh)"
sh -c "$(wget -qO- https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh)"
