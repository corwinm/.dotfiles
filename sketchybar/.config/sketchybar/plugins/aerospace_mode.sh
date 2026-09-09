#!/usr/bin/env bash

item="${NAME:-aerospace_mode}"
mode="${MODE:-$(aerospace list-modes --current)}"

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  normal_color=0xff638989
  agent_color=0xff1e6e77
  window_color=0xffce3a5b
else
  normal_color=0xff40a02b
  agent_color=0xff1e66f5
  window_color=0xffd20f39
fi

case "$mode" in
  agent)
    sketchybar --set "$item" drawing=on icon="󰚩" icon.color="$agent_color"
    ;;
  window)
    sketchybar --set "$item" drawing=on icon="" icon.color="$window_color"
    ;;
  *)
    sketchybar --set "$item" drawing=on icon="●" icon.color="$normal_color"
    ;;
esac
