#!/usr/bin/env bash

item="${NAME:-aerospace_mode}"
mode="${MODE:-$(aerospace list-modes --current)}"

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  normal_color=0xff638989
  window_color=0xffce3a5b
else
  normal_color=0xff40a02b
  window_color=0xffd20f39
fi

if [[ "$mode" == "window" ]]; then
  sketchybar --set "$item" drawing=on icon="W" icon.color="$window_color"
else
  sketchybar --set "$item" drawing=on icon="●" icon.color="$normal_color"
fi
