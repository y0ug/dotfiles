#!/usr/bin/env bash
CMD="wallpaper-downloader -provider unsplash"
WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
LAST_UPDATE_FILE="/tmp/wallpaper-last-update"
UPDATE_INTERVAL=$((30 * 60)) # 30 minutes in seconds
DARK_THRESHOLD=25000

setup() {
  cat <<'EOF_1738964388_12111' >"$HOME/.config/systemd/user/random-wallpaper.service"
[Unit]
Description=Random Wallpaper Service
After=graphical-session.target [Service]
Type=oneshot
ExecStart=%h/.local/bin/random-wallpaper.sh
# Environment= 
[Install]
WantedBy=graphical-session.target,hyprpaper.service
EOF_1738964388_12111
  cat <<'EOF_1738964388_12111' >"$HOME/.config/systemd/user/random-wallpaper.timer"
[Unit]
Description=Run Random Wallpaper Service periodically
[Timer]
OnBootSec=1min
OnUnitActiveSec=10min
Persistent=true
[Install]
WantedBy=timers.target
EOF_1738964388_12111
  systemctl --user daemon-reload
  systemctl --user enable random-wallpaper.timer
  systemctl --user start random-wallpaper.timer
}

calculate_brightness() {
  local img="$1"
  local meta_file="${img}.meta.json"

  # Check if metadata file exists and contains brightness
  if [ -f "$meta_file" ] && grep -q "brightness" "$meta_file"; then
    # Extract brightness from metadata file
    brightness=$(grep -o '"brightness":[0-9]*' "$meta_file" | cut -d':' -f2)
  else
    # Calculate brightness using magick command
    brightness=$(magick "$img" -colorspace HSI -channel b -separate +channel -format "%[mean]" info:)

    # Remove decimal part if present
    brightness=${brightness%.*}

    # Save brightness in metadata file
    echo "{\"brightness\":$brightness}" >"$meta_file"
  fi

  echo "$brightness"
}

update_wallpaper_metadata() {
  echo "Updating wallpaper metadata..."

  # Process all images in wallpaper folder
  for img in "$WALLPAPER_DIR"/*.jpg "$WALLPAPER_DIR"/*.png "$WALLPAPER_DIR"/*.jpeg; do
    # Skip if not a file
    [ -f "$img" ] || continue

    # Get filename only
    filename=$(basename "$img")
    meta_file="${img}.meta.json"

    # Skip if metadata already exists
    if [ -f "$meta_file" ] && grep -q "brightness" "$meta_file"; then
      continue
    fi

    # Calculate and save brightness
    brightness=$(calculate_brightness "$img")
    echo "Processed $filename - Brightness: $brightness"
  done

  echo "Wallpaper metadata update completed."
}

check_for_updates() {
  current_time=$(date +%s)
  # Create update file if it doesn't exist
  if [ ! -f "$LAST_UPDATE_FILE" ]; then
    echo "0" >"$LAST_UPDATE_FILE"
  fi
  last_update=$(cat "$LAST_UPDATE_FILE")
  time_diff=$((current_time - last_update))
  if [ "$1" = "--update" ] || [ $time_diff -ge $UPDATE_INTERVAL ]; then
    $CMD
    update_wallpaper_metadata
    echo "$current_time" >"$LAST_UPDATE_FILE"
  fi
}

change_wallpaper() {
  CURRENT_WALL=$(hyprctl hyprpaper listloaded)

  # Choose dark or any wallpaper based on time of day or argument
  HOUR=$(date +%H)
  USE_DARK=0

  if [ "$1" = "--dark" ] || [ $HOUR -ge 19 ] || [ $HOUR -le 6 ]; then
    USE_DARK=1
  fi

  # Get all wallpapers excluding current one
  WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) ! -name "$(basename "$CURRENT_WALL")" | sort)

  if [ $USE_DARK -eq 1 ]; then
    # Find a dark wallpaper
    while IFS= read -r img; do
      # Skip if not a file
      [ -f "$img" ] || continue

      # Get brightness
      brightness=$(calculate_brightness "$img")

      # Check if dark enough
      if [ "${brightness:-100000}" -lt "$DARK_THRESHOLD" ]; then
        WALLPAPER="$img"
        echo "Setting dark wallpaper: $(basename "$WALLPAPER") (Brightness: $brightness)"
        break
      fi
    done <<<"$WALLPAPERS"

    # If no dark wallpaper found, pick random
    if [ -z "$WALLPAPER" ]; then
      WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
      echo "No dark wallpapers found, using random wallpaper: $(basename "$WALLPAPER")"
    fi
  else
    # Use any wallpaper during the day
    WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
    echo "Setting regular wallpaper: $(basename "$WALLPAPER")"
  fi

  # Apply the selected wallpaper
  hyprctl hyprpaper reload ,"$WALLPAPER"
  # Update hyprlock config
  sed -i "s|path *= */[^}]*|path = $WALLPAPER|" ~/.config/hypr/hyprlock-background.conf
  echo "$WALLPAPER" >~/.config/hypr/hyprlock-update-wallpaper
  pkill -USR2 hyprlock
}

# Parse arguments
if [ "$1" = "--setup" ]; then
  setup
  exit 0
elif [ "$1" = "--update-metadata" ]; then
  update_wallpaper_metadata
  exit 0
fi

# Check for updates
check_for_updates "$1"

# Change wallpaper
change_wallpaper "$1"
