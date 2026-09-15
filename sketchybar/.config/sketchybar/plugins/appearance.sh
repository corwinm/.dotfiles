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
  MUTED=0xffa5adcb
  PILL=0xd91e1e2e
  POPUP=0xff1e1e2e
  BORDER=0xff45475a
  BORDER_ACTIVE=0xff1e6e77
  BORDER_INACTIVE=0xff45475a
else
  BLUE=0xff1e66f5
  ORANGE=0xfffe640b
  PINK=0xffea76cb
  RED=0xffd20f39
  GREEN=0xff40a02b
  PURPLE=0xff8839ef
  CREAM=0xff5c5f77
  TEXT=0xff4c4f69
  MUTED=0xff8c8fa1
  PILL=0xd9eff1f5
  POPUP=0xffeff1f5
  BORDER=0xffacb0be
  BORDER_ACTIVE=0xff4a90ff
  BORDER_INACTIVE=0xffacb0be
fi
APPLE_COLOR="$MUTED"

args=(
  --default icon.color="$MUTED" label.color="$TEXT" background.color="$PILL" background.border_color="$BORDER"
  --set appearance_watcher drawing=off icon="" label="" background.drawing=off
  --set apple_menu icon.color="$APPLE_COLOR" popup.background.color="$POPUP" popup.background.border_color="$BORDER"
  --set left_status background.color="$PILL" background.border_color="$BORDER"
  --set workspace_separator background.color="$MUTED"
  --set front_app background.drawing=off icon.color="$MUTED" label.color="$TEXT" popup.background.color="$POPUP" popup.background.border_color="$BORDER"
  --set system_status background.color="$PILL" background.border_color="$BORDER"
  --set coding-agents background.drawing=off popup.background.color="$POPUP"
  --set time background.drawing=off icon.color="$MUTED" label.color="$TEXT"
  --set date background.drawing=off icon.color="$MUTED" label.color="$TEXT" popup.background.color="$POPUP" popup.background.border_color="$BORDER"
  --set volume background.drawing=off icon.color="$MUTED" label.color="$TEXT"
  --set battery background.drawing=off icon.color="$MUTED" label.color="$TEXT"
  --set time_machine background.drawing=off icon.color="$BLUE" label.color="$TEXT"
  --set network_offline background.drawing=off icon.color="$ORANGE" label.color="$TEXT"
  --set camera_active background.drawing=off icon.color="$GREEN" label.color="$TEXT"
  --set microphone_active background.drawing=off icon.color="$ORANGE" label.color="$TEXT"
)

for action in about settings activity lock; do
  args+=(--set "apple.$action" icon.color="$PINK" label.color="$TEXT")
done
for action in new settings hide quit; do
  args+=(--set "front-app.$action" icon.color="$CREAM" label.color="$TEXT")
done
for sid in {1..9}; do
  args+=(--set "space.$sid" background.color="$BLUE")
done
for index in {1..9}; do
  args+=(--set "coding-agent.$index" label.color="$TEXT")
done
args+=(--set coding-agent.chooser icon.color="$CREAM" label.color="$TEXT")
for row in {0..7}; do
  args+=(--set "calendar.$row" background.color="$PILL")
done

# Apply every palette property in a single transaction so the bar never
# disappears or shows a partially switched theme.
sketchybar "${args[@]}"

# Keep JankyBorders in sync with the active palette.
if command -v borders >/dev/null 2>&1; then
  borders active_color="$BORDER_ACTIVE" inactive_color="$BORDER_INACTIVE" >/dev/null 2>&1
fi

# Re-evaluate state-dependent colors after the palette changes.
"$CONFIG_DIR/plugins/aerospace.sh"
NAME=aerospace_mode "$CONFIG_DIR/plugins/aerospace_mode.sh"
"$CONFIG_DIR/plugins/calendar.sh" render
NAME=battery "$CONFIG_DIR/plugins/battery.sh"
NAME=volume "$CONFIG_DIR/plugins/volume.sh"
NAME=coding-agents "$CONFIG_DIR/plugins/coding_agents.sh"
