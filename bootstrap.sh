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

apt update && apt install sudo curl wget git jq
CHEZMOI_MODE=home
sh -c "$(curl -fsLS https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh)"
