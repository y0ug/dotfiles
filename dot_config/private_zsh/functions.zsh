# Load environment variables from an encrypted SOPS file
load_env() {
  local env_file="$HOME/.config/env/$1.sops.env"

  if [[ ! -f "$env_file" ]]; then
    echo "❌ Error: Environment file '$env_file' not found!"
    return 1
  fi
  
  set -a
  eval "$(sops -d "$env_file" | sed 's/^export //')"
  set +a
  export SOPS_ENV_LOADED="$env_file"

  echo "✅ Loaded environment from $env_file"
}

# Unload environment variables from a previously loaded file
unload_env() {
  local env_file="$HOME/.config/env/$1.sops.env"

  if [[ -z "$1" ]]; then
    echo "⚠️ Please specify an environment name to unload."
    return 1
  fi

  if [[ ! -f "$env_file" ]]; then
    echo "❌ Error: Environment file '$env_file' not found!"
    return 1
  fi

  while IFS='=' read -r key _; do
    unset "$key"
  done < <(sops -d "$env_file" | grep -E '^[A-Za-z_][A-Za-z0-9_]*=')

  echo "🗑️ Unloaded environment from $env_file"
}


# copy file to clipboard  with heredoc to recreate it
copy_file() {
    # Check if any files were provided
    if [ $# -eq 0 ]; then
        echo "Error: No files specified."
        echo "Usage: copy_file file1 [file2 ...]"
        return 1
    fi 

    # Detect clipboard command based on system
    local clip_cmd
    case "$(uname -s)" in
        Linux*)
            if [ -n "$WSL_DISTRO_NAME" ]; then
                # WSL environment
                clip_cmd="clip.exe"
            elif command -v xclip >/dev/null 2>&1; then
                clip_cmd="xclip -selection clipboard"
            elif command -v xsel >/dev/null 2>&1; then
                clip_cmd="xsel --clipboard --input"
            else
                echo "Error: Please install xclip or xsel for clipboard support"
                return 1
            fi
            ;;
        Darwin*)  # macOS
            clip_cmd="pbcopy"
            ;;
        *)
            echo "Error: Unsupported operating system"
            return 1
            ;;
    esac

    # Generate a unique delimiter
    local delimiter="EOF_$(date +%s)_${RANDOM}"
    
    # Process all files
    {
        for filename in "$@"; do
            if [ ! -f "$filename" ]; then
                echo "Warning: File '$filename' does not exist, skipping." >&2
                continue
            fi
            
            echo "# File: $filename"
            echo "cat << '$delimiter' > '$filename'"
            cat "$filename"
            echo "$delimiter"
            echo
        done
    } | eval "$clip_cmd"

    echo "Copied ${#} file(s) to clipboard as heredoc commands"
}

git_new_release() {
  local FORCE=0

  # Parse options
  while getopts ":f" opt; do
    case ${opt} in
      f )
        FORCE=1
        ;;
      \? )
        echo "Invalid Option: -$OPTARG" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND -1))

  # Function to display error messages
  error() {
    echo "Error: $1" >&2
    return 1
  }

  # Function to prompt user for confirmation
  confirm() {
    while true; do
      read "REPLY?Are you sure you want to create and push the new tag? [y/N]: "
      case "$REPLY" in
        [yY]|[yY][eE][sS])
          return 0
          ;;
        [nN]|[nN][oO]|"")
          return 1
          ;;
        *)
          echo "Please answer yes or no."
          ;;
      esac
    done
  }

  # Fetch all tags from the remote repository
  echo "Fetching tags from remote..."
  # git fetch --tags || error "Failed to fetch tags." && return 1

  echo "Foo"
  # Get the latest tag matching the pattern vX.Y.Z
  latest_tag=$(git describe --tags `git rev-list --tags --max-count=1` 2>/dev/null) || error "No tags found in the repository." && return 1

  echo "Latest tag found: $latest_tag"

  # Extract version numbers using regex
  if [[ $latest_tag =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    major=${match[1]}
    minor=${match[2]}
    patch=${match[3]}
  else
    # Using BASH_REMATCH equivalent in Zsh
    if [[ $latest_tag =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
      major=${match[1]}
      minor=${match[2]}
      patch=${match[3]}
    else
      error "Latest tag '$latest_tag' does not match the pattern vX.Y.Z."
      return 1
    fi
  fi

  echo "Current version: $major.$minor.$patch"

  # Increment the patch number
  new_patch=$((patch + 1))
  new_tag="v$major.$minor.$new_patch"

  echo "New tag to be created: $new_tag"

  # If not forcing, prompt for confirmation
  if [[ $FORCE -ne 1 ]]; then
    if ! confirm; then
      echo "Operation cancelled by user."
      return 0
    fi
  fi

  # Create the new tag
  echo "Creating new tag: $new_tag"
  git tag "$new_tag" || error "Failed to create tag '$new_tag'." && return 1

  # Push the new tag to the remote repository
  echo "Pushing tag '$new_tag' to remote..."
  git push origin "$new_tag" || error "Failed to push tag '$new_tag' to remote." && return 1

  echo "Tag '$new_tag' pushed successfully."

  # Create a GitHub release based on the new tag
  echo "Creating GitHub release for tag '$new_tag'..."
  gh release create "$new_tag" --notes-from-tag --verify-tag
  if [[ $? -ne 0 ]]; then
    error "Failed to create GitHub release for '$new_tag'."
    return 1
  fi

  echo "GitHub release '$new_tag' created successfully."
}


