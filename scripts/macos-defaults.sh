#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script only supports macOS." >&2
  exit 1
fi

# Make the Dock appear immediately and animate quickly when auto-hide is enabled.
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Restart the Dock once so both changes take effect.
killall Dock

echo "macOS Dock defaults applied."
