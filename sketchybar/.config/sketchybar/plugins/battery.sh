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

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  muted=0xffa5adcb
  green=0xff638989
  red=0xffce3a5b
else
  muted=0xff8c8fa1
  green=0xff40a02b
  red=0xffd20f39
fi

color="$muted"
if [[ "$battery_info" == *"AC Power"* ]]; then
  icon=""
  color="$green"
elif (( level <= 20 )); then
  color="$red"
fi

sketchybar --set "$item" drawing=on icon="$icon" icon.color="$color" label="$percentage"
