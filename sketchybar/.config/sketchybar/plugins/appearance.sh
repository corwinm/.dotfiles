#!/usr/bin/env bash

# Ignore the routine event emitted by `sketchybar --update`; react only to an
# actual macOS appearance change.
[[ "${SENDER:-}" == "system_appearance_changed" ]] || exit 0
sleep 0.2

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  BLUE=0xff1e6e77
  ORANGE=0xffcc7b6e
  PINK=0xffd7448a
  RED=0xffce3a5b
  GREEN=0xff638989
  PURPLE=0xff8c6bc8
  CREAM=0xffd3cdc5
  TEXT=0xffffffff
  PILL=0xeb1e1e2e
  POPUP=0xff1e1e2e
else
  BLUE=0xff1e66f5
  ORANGE=0xfffe640b
  PINK=0xffea76cb
  RED=0xffd20f39
  GREEN=0xff40a02b
  PURPLE=0xff8839ef
  CREAM=0xff5c5f77
  TEXT=0xff4c4f69
  PILL=0xeee6e9ef
  POPUP=0xffeff1f5
fi

args=(
  --default icon.color="$TEXT" label.color="$TEXT" background.color="$PILL"
  --set appearance_watcher drawing=off icon="" label="" background.drawing=off
  --set workspaces background.color="$PILL" background.border_color="$PINK"
  --set workspace_separator background.color="$CREAM"
  --set front_app background.color="$PILL" background.border_color="$CREAM" label.color="$TEXT"
  --set coding-agents background.color="$PILL"
  --set time background.color="$PILL" background.border_color="$PURPLE" icon.color="$PURPLE" label.color="$TEXT"
  --set date background.color="$PILL" background.border_color="$GREEN" icon.color="$GREEN" label.color="$TEXT" popup.background.color="$POPUP" popup.background.border_color="$GREEN"
  --set volume background.color="$PILL" background.border_color="$ORANGE" icon.color="$ORANGE" label.color="$TEXT"
  --set battery background.color="$PILL" background.border_color="$RED" icon.color="$RED" label.color="$TEXT"
  --set time_machine background.color="$PILL" background.border_color="$BLUE" icon.color="$BLUE" label.color="$TEXT"
  --set network_offline background.color="$PILL" background.border_color="$ORANGE" icon.color="$ORANGE" label.color="$TEXT"
  --set camera_active background.color="$PILL" background.border_color="$GREEN" icon.color="$GREEN" label.color="$TEXT"
  --set microphone_active background.color="$PILL" background.border_color="$ORANGE" icon.color="$ORANGE" label.color="$TEXT"
)

for sid in {1..9}; do
  args+=(--set "space.$sid" background.color="$BLUE")
done
for row in {0..7}; do
  args+=(--set "calendar.$row" background.color="$PILL")
done

# Apply every palette property in a single transaction so the bar never
# disappears or shows a partially switched theme.
sketchybar "${args[@]}"

# Re-evaluate state-dependent colors after the palette changes.
"$CONFIG_DIR/plugins/aerospace.sh"
NAME=aerospace_mode "$CONFIG_DIR/plugins/aerospace_mode.sh"
"$CONFIG_DIR/plugins/calendar.sh" render
NAME=coding-agents "$CONFIG_DIR/plugins/coding_agents.sh"
