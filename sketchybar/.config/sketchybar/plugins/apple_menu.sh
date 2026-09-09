#!/usr/bin/env bash

set -euo pipefail

action="${1:-toggle}"

close_popup() {
  sketchybar --set apple_menu popup.drawing=off
}

case "$action" in
  toggle)
    sketchybar --set apple_menu popup.drawing=toggle
    ;;
  dismiss)
    close_popup
    ;;
  about)
    close_popup
    open 'x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension'
    ;;
  settings)
    close_popup
    open -a "System Settings"
    ;;
  activity)
    close_popup
    open -a "Activity Monitor"
    ;;
  lock)
    close_popup
    osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
    ;;
  *)
    printf 'unknown Apple menu action: %s\n' "$action" >&2
    exit 2
    ;;
esac
