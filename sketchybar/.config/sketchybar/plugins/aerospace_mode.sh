#!/usr/bin/env bash

item="${NAME:-aerospace_mode}"
mode="${MODE:-$(aerospace list-modes --current)}"

if [[ "$mode" == "window" ]]; then
  sketchybar --set "$item" drawing=on icon="W" icon.color=0xffce3a5b
else
  sketchybar --set "$item" drawing=on icon="●" icon.color=0xff638989
fi
