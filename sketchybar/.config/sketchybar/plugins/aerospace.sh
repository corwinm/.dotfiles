#!/usr/bin/env bash

focused="$(aerospace list-workspaces --focused)"
populated="$(aerospace list-windows --all --format '%{workspace}' | sort -u)"
left_visible=false
right_visible=false
args=()

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  inactive_color=0xffffffff
else
  inactive_color=0xff4c4f69
fi

for sid in {1..9}; do
  visible=off
  background=off
  icon_color="$inactive_color"

  if [[ "$sid" == "$focused" ]] || grep -Fxq "$sid" <<< "$populated"; then
    visible=on
    if (( sid <= 5 )); then
      left_visible=true
    else
      right_visible=true
    fi
  fi

  if [[ "$sid" == "$focused" ]]; then
    background=on
    icon_color=0xffffffff
  fi

  args+=(--set "space.$sid" \
    drawing="$visible" \
    background.drawing="$background" \
    icon.color="$icon_color")
done

separator=off
[[ "$left_visible" == true && "$right_visible" == true ]] && separator=on
args+=(--set workspace_separator drawing="$separator")

sketchybar "${args[@]}"
