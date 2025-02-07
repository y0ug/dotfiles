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
            elif command -v wl-copy >/dev/null 2>&1; then
                clip_cmd="wl-copy"
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

getmarkdown() {
  curl -X GET "https://fuckyeahmarkdown.com/api/2/?url=$1&readability=1&inline=0&json=1&link=url&format=markdown_mmd" | jq --raw-output .markup
}
