#!/usr/bin/env bash

# Get the current working directory
current_dir=$(pwd)

# Get the JSON output from kitty @ ls
kitty_json=$(kitty @ ls)

# Extract the active tab ID
active_tab_id=$(echo "$kitty_json" | jq -r '.[] | .tabs[] | select(.is_active == true) | .id')

# Get all window IDs in the active tab
window_ids=$(echo "$kitty_json" | jq -r --arg tab_id "$active_tab_id" '
    .[] | .tabs[] | select(.id == ($tab_id | tonumber)) | .windows[].id')

# Send the 'cd' command only to windows in the current active tab
for id in $window_ids; do
  kitty @ send-text --match id:$id "cd $current_dir\n"
done

echo "Changed directory of all windows in the active tab to: $current_dir"
