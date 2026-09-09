#!/usr/bin/env bash

set -euo pipefail

action="${1:-toggle}"

close_popup() {
  sketchybar --set front_app popup.drawing=off
}

send_shortcut() {
  local key="$1"
  close_popup
  osascript - "$key" <<'APPLESCRIPT'
on run argv
  set shortcutKey to item 1 of argv
  tell application "System Events"
    set frontProcess to first application process whose frontmost is true
    set frontmost of frontProcess to true
    keystroke shortcutKey using command down
  end tell
end run
APPLESCRIPT
}

case "$action" in
  toggle)
    sketchybar --set front_app popup.drawing=toggle
    ;;
  dismiss)
    close_popup
    ;;
  new)
    send_shortcut "n"
    ;;
  settings)
    send_shortcut ","
    ;;
  hide)
    send_shortcut "h"
    ;;
  quit)
    send_shortcut "q"
    ;;
  *)
    printf 'unknown front-app menu action: %s\n' "$action" >&2
    exit 2
    ;;
esac
