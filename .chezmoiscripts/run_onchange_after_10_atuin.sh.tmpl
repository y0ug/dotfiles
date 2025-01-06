#!/usr/bin/env bash
{{ if .is_home }}
# set -eufo pipefail

if ! command -v bw &> /dev/null; then
  echo "No Bitwarden"
  exit 0
fi

# Check if Bitwarden is unlocked
if ! bw status | grep -q '"status":"unlocked"'; then
  echo "Bitwarden is not unlocked. Please unlock it first."
  exit 0
fi

# Check if Atuin is installed
if ! command -v atuin &> /dev/null; then
  echo "Atuin is not installed. Please install it first."
  exit 0
fi

# Check if Atuin is already set up (has a valid session file)
if [ -f "$HOME/.local/share/atuin/session" ] && [ -s "$HOME/.local/share/atuin/session" ]; then
  echo "Atuin is already set up and logged in."
  exit 0
fi

echo "Logging in to atuin..."
if atuin login -u rick3 \
  -p $(bw list items --search atuin |  jq -r '.[0].fields[] | select(.name=="password").value') 
  -k $(bw list items --search atuin |  jq -r '.[0].fields[] | select(.name=="key").value')
  echo "Logged in to atuin."
  atuin sync
else
  echo "Failed to login to atuin."
fi
{{ end }}
