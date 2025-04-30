#!/usr/bin/env bash

# osc52.sh - Copy text to clipboard using OSC 52 escape sequence
# Usage: osc52.sh [file]
#   If file is provided, copies file content to clipboard
#   If no file is provided, copies stdin to clipboard

# Max size in bytes (96KB is a common limit for terminals)
MAX_SIZE=96000

# Function to encode content in base64 and send OSC 52 sequence
function send_osc52() {
  local content=$1
  local content_bytes=$(echo -n "$content" | wc -c)

  if [ "$content_bytes" -gt "$MAX_SIZE" ]; then
    echo "Warning: Content size ($content_bytes bytes) exceeds recommended limit ($MAX_SIZE bytes)" >&2
    echo "The terminal might truncate the data" >&2
  fi

  # Base64 encode the content
  local encoded=$(echo -n "$content" | base64 | tr -d '\n')

  # Send the OSC 52 escape sequence
  printf "\033]52;c;%s\a" "$encoded"

  echo "Copied $content_bytes bytes to clipboard" >&2
}

# Main logic
if [ "$#" -eq 0 ]; then
  # No arguments, read from stdin
  content=$(cat)
  send_osc52 "$content"
elif [ "$#" -eq 1 ]; then
  # One argument, read from file
  if [ ! -f "$1" ]; then
    echo "Error: File not found: $1" >&2
    exit 1
  fi
  content=$(cat "$1")
  send_osc52 "$content"
else
  # Too many arguments
  echo "Usage: $0 [file]" >&2
  echo "  If file is provided, copies file content to clipboard" >&2
  echo "  If no file is provided, copies stdin to clipboard" >&2
  exit 1
fi
