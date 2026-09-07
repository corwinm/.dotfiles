#!/usr/bin/env bash

item="${NAME:-network_offline}"
interfaces="$(scutil --nwi 2>/dev/null | awk -F': ' '/^Network interfaces:/ { print $2 }')"

if grep -Eq '(^|[ ,])en[0-9]+($|[ ,])' <<< "$interfaces"; then
  sketchybar --set "$item" drawing=off
else
  sketchybar --set "$item" drawing=on
fi
