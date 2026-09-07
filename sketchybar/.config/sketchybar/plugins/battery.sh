#!/usr/bin/env bash

item="${NAME:-battery}"
battery_info="$(pmset -g batt)"
percentage="$(printf '%s\n' "$battery_info" | grep -Eo '[0-9]+%' | head -1)"
level="${percentage%%%}"

[[ -z "$level" ]] && exit 0

case "$level" in
  100|[8-9][0-9]) icon="" ;;
  7[0-9])         icon="" ;;
  [4-6][0-9])     icon="" ;;
  [1-3][0-9])     icon="" ;;
  *)              icon="" ;;
esac

[[ "$battery_info" == *"AC Power"* ]] && icon=""
sketchybar --set "$item" icon="$icon" label="$percentage"
