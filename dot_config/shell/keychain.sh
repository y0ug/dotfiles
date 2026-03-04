# keychain.sh - SSH agent caching via keychain

# if [[ -z "$SSH_AUTH_SOCK" && -z "$SSH_AGENT_PID" ]] && command -v keychain &>/dev/null; then
#   KEYCHAIN_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/keychain"
#   _is_ssh_agent_valid() {
#     [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" && \
#        -n "$SSH_AGENT_PID" && -d "/proc/$SSH_AGENT_PID" ]]
#   }
#   if [[ -f "$KEYCHAIN_CACHE" ]]; then
#     source "$KEYCHAIN_CACHE"
#     if ! _is_ssh_agent_valid; then
#       keychain --eval -q > "$KEYCHAIN_CACHE"
#       source "$KEYCHAIN_CACHE"
#     fi
#   else
#     keychain --eval -q > "$KEYCHAIN_CACHE"
#     source "$KEYCHAIN_CACHE"
#   fi
#   unset -f _is_ssh_agent_valid
# fi
