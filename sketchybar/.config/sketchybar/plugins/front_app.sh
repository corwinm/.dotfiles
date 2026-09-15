#!/usr/bin/env bash

item="${NAME:-front_app}"
app="${INFO:-$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)}"

# Nerd Font glyphs provide a compact visual anchor without adding an app-icon
# dependency. Unknown applications use the generic application symbol.
case "${app:-Desktop}" in
  Finder)                         icon="󰀶" ;;
  "Google Chrome"|Chrome)         icon="" ;;
  Ghostty|ghostty)                icon="󰊠" ;;
  Discord)                        icon="󰙯" ;;
  Messages)                       icon="󰍡" ;;
  "Visual Studio Code"|Code)      icon="󰨞" ;;
  "System Settings"|Preferences) icon="" ;;
  Bitwarden)                      icon="󰞀" ;;
  Preview)                        icon="" ;;
  Slack)                          icon="󰒱" ;;
  "Microsoft Outlook"|Outlook)   icon="󰴢" ;;
  "Microsoft Teams"|Teams)       icon="󰊻" ;;
  ChatGPT)                        icon="󰭹" ;;
  *)                              icon="󰀻" ;;
esac

sketchybar --set "$item" icon="$icon" label="${app:-Desktop}"
