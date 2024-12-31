apt update && apt install sudo curl wget git
CHEZMOI_MODE=home
sh -c "$(curl -fsLS https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh)"
sh -c "$(wget -qO- https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh)"
