#!/usr/bin/env zsh
# load_env.sh llm
env_file="$HOME/.config/env/llm.sops.env"
set -a
#eval "$(sops -d "$env_file") #| sed 's/^export //')"
#. <(sops -d "$env_file") #| sed 's/^export //')
source load_env.sh llm
set +a
env | grep API
notify-send "Processing" "$(wl-paste | head -c 30)..." &&
  wl-paste |
  if [ "$(wl-paste | wc -c)" -le 2000 ]; then
    aichat -r correct | wl-copy &&
      notify-send "Completed" "$(wl-copy -p | head -c 30)..." ||
      notify-send "Failed" "Error during processing"
  else
    notify-send "Failed" "Content too large ($(wl-paste | wc -c) bytes)" && false
  fi
