#!/usr/bin/env bash

item="${NAME:-battery}"
battery_info="$(pmset -g batt)"
percentage="$(printf '%s\n' "$battery_info" | grep -Eo '[0-9]+%' | head -1)"
level="${percentage%%%}"

# Desktop Macs and systems without an internal battery do not report a charge
# percentage. Hide the item until battery data becomes available.
if ! [[ "$level" =~ ^[0-9]+$ ]]; then
  sketchybar --set "$item" drawing=off
  exit 0
fi

case "$level" in
  100|[8-9][0-9]) icon="" ;;
  7[0-9])         icon="" ;;
  [4-6][0-9])     icon="" ;;
  [1-3][0-9])     icon="" ;;
  *)              icon="" ;;
esac

[[ "$battery_info" == *"AC Power"* ]] && icon=""
sketchybar --set "$item" drawing=on icon="$icon" label="$percentage"
