#!/usr/bin/env bash

set -u

config_dir="${CONFIG_DIR:-$HOME/.config/sketchybar}"
state_dir="${TMPDIR:-/tmp}/sketchybar-workspace-menu"
mkdir -p "$state_dir"

# Window rows exist only while a menu is open. Every idle item makes each
# SketchyBar command slower, so rows are created on open and removed on close.
close_menus() {
  local args=()
  for sid in {1..9}; do
    args+=(--set "space.$sid" popup.drawing=off)
  done
  sketchybar "${args[@]}" --remove '/workspace_menu\..*/' >/dev/null 2>&1
}

# Popup rows send this event when the pointer leaves the bar or popup.
if [[ "${SENDER:-}" == "mouse.exited.global" ]]; then
  close_menus
  exit 0
fi

workspace="${2:-}"
row="${3:-}"

if [[ "${1:-}" == "focus" ]]; then
  window_id=""
  [[ -f "$state_dir/$workspace" ]] && window_id="$(sed -n "$((row + 1))p" "$state_dir/$workspace")"
  close_menus
  [[ "$window_id" =~ ^[0-9]+$ ]] && aerospace focus --window-id "$window_id"
  exit 0
fi

# Left-click retains the existing workspace-switching behavior.
if [[ "${BUTTON:-left}" != "right" ]]; then
  close_menus
  aerospace workspace "$workspace"
  exit 0
fi

close_menus

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  BLUE=0xff1e6e77
  TEXT=0xffffffff
else
  BLUE=0xff1e66f5
  TEXT=0xff4c4f69
fi

: > "$state_dir/$workspace"
args=()
index=0
while IFS='|' read -r window_id app_name window_title; do
  [[ -z "$window_id" ]] && continue
  printf '%s\n' "$window_id" >> "$state_dir/$workspace"
  label="$app_name"
  [[ -n "$window_title" ]] && label="$label — $window_title"
  item="workspace_menu.$workspace.$((index + 1))"
  args+=(--add item "$item" popup."space.$workspace"
    --set "$item"
      icon="󰖲"
      icon.color="$BLUE"
      icon.width=22
      icon.padding_left=10
      icon.padding_right=6
      label="$label"
      label.color="$TEXT"
      label.width=360
      label.align=left
      label.padding_left=0
      label.padding_right=12
      background.drawing=off
      click_script="$config_dir/plugins/workspace_menu.sh focus $workspace $index")
  index=$((index + 1))
done < <(aerospace list-windows --workspace "$workspace" --format '%{window-id}|%{app-name}|%{window-title}' 2>/dev/null)

(( index == 0 )) && exit 0

# The first row receives SketchyBar's global mouse-exit event, matching the
# dismissal behavior of the other native popups.
sketchybar "${args[@]}" \
  --set "workspace_menu.$workspace.1" script="$config_dir/plugins/workspace_menu.sh" \
  --subscribe "workspace_menu.$workspace.1" mouse.exited.global \
  --set "space.$workspace" popup.drawing=on
