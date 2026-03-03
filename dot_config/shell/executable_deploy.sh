#!/usr/bin/env bash
# deploy.sh - Deploy shell config to a remote host over SSH
#
# Usage:
#   ./deploy.sh user@host            # install both zsh + bash
#   ./deploy.sh user@host zsh        # zsh only
#   ./deploy.sh user@host bash       # bash only

set -euo pipefail

host="${1:?Usage: $0 user@host [zsh|bash|all]}"
target="${2:-all}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Deploying shell config to $host ..."
"$script_dir/bundle.sh" | ssh "$host" "bash -s -- $target"
echo "Done."
