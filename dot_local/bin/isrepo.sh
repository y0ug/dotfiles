#!/bin/bash
# Recursively list all directories starting from the current directory
fd --type d . --max-depth 1 | while IFS= read -r dir; do
  if [ -d "$dir/.git" ]; then
    pushd "$dir" >/dev/null # Enter the Git repository directory silently
    status=$(git status --porcelain)
    if [ -z "$status" ]; then
      echo "$dir is a git repo and is clean"
    else
      echo "$dir is a git repo and is dirty:"
      # Process each line of git status output
      while IFS= read -r line; do
        if [[ $line == '??'* ]]; then
          echo "  Untracked: $line"
        else
          # Determine if the change is staged, unstaged, or both.
          changes=()
          # First column: staged changes (if not a space)
          if [[ ${line:0:1} != " " ]]; then
            changes+=("staged")
          fi
          # Second column: unstaged changes (if not a space)
          if [[ ${line:1:1} != " " ]]; then
            changes+=("unstaged")
          fi
          # Join statuses if more than one applies.
          echo "  ${changes[*]}: $line"
        fi
      done <<<"$status"
    fi
    popd >/dev/null # Return to the previous directory
  # else
  #   echo "$dir is not a git repository"
  fi
done
