#!/usr/bin/env bash

set -u

config_dir="${CONFIG_DIR:-$HOME/.config/sketchybar}"
state_dir="${TMPDIR:-/tmp}/sketchybar-workspace-menu"
mkdir -p "$state_dir"

close_menus() {
  for sid in {1..9}; do
    sketchybar --set "space.$sid" popup.drawing=off
  done
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

if [[ "${1:-}" == "switch" ]]; then
  close_menus
  aerospace workspace "$workspace"
  exit 0
fi

# Left-click retains the existing workspace-switching behavior.
if [[ "${BUTTON:-left}" != "right" ]]; then
  close_menus
  aerospace workspace "$workspace"
  exit 0
fi

close_menus

# Must match the number of popup rows created per workspace in sketchybarrc.
max_rows=12

windows=()
while IFS= read -r line; do
  [[ -n "$line" ]] && windows+=("$line")
done < <(aerospace list-windows --workspace "$workspace" --format '%{window-id}|%{app-name}|%{window-title}' 2>/dev/null)

# When the workspace has more windows than rows, the last row summarizes the
# rest and switches to the workspace instead of focusing one window.
shown=${#windows[@]}
(( shown > max_rows )) && shown=$((max_rows - 1))

: > "$state_dir/$workspace"
args=()
for (( row = 1; row <= max_rows; row++ )); do
  args+=(--set "workspace_menu.$workspace.$row" drawing=off)
done

for (( index = 0; index < shown; index++ )); do
  IFS='|' read -r window_id app_name window_title <<< "${windows[$index]}"
  printf '%s\n' "$window_id" >> "$state_dir/$workspace"
  label="$app_name"
  [[ -n "$window_title" ]] && label="$label — $window_title"
  args+=(--set "workspace_menu.$workspace.$((index + 1))"
    drawing=on
    icon="󰖲"
    label="$label"
    click_script="$config_dir/plugins/workspace_menu.sh focus $workspace $index")
done

if (( ${#windows[@]} > shown )); then
  args+=(--set "workspace_menu.$workspace.$max_rows"
    drawing=on
    icon="…"
    label="and $(( ${#windows[@]} - shown )) more"
    click_script="$config_dir/plugins/workspace_menu.sh switch $workspace")
fi

sketchybar "${args[@]}" --set "space.$workspace" popup.drawing=on
