#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script only supports macOS." >&2
  exit 1
fi

# Make the Dock appear immediately and animate quickly when auto-hide is enabled.
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Keep the native menu bar hidden so it does not overlap SketchyBar. On newer
# macOS releases, writing _HIHideMenuBar alone updates the preference file but
# does not reliably apply the setting to the current session. Set both backing
# preferences and ask System Events to apply the change through macOS.
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false
defaults write NSGlobalDomain SLSMenuBarUseBlurredAppearance -bool true
osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to true'

# Restart affected system processes so the changes take effect immediately.
killall Dock
killall SystemUIServer

echo "macOS Dock and menu bar defaults applied."
