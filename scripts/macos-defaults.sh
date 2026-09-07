#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script only supports macOS." >&2
  exit 1
fi

# Make the Dock appear immediately and animate quickly when auto-hide is enabled.
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Keep the native menu bar hidden so it does not overlap SketchyBar.
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Restart affected system processes so the changes take effect immediately.
killall Dock
killall SystemUIServer

echo "macOS Dock and menu bar defaults applied."
