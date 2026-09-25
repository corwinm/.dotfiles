#!/usr/bin/env bash

# Toggle the AeroSpace cheatsheet for the mode that is active right now.
# The popup rows are created by sketchybarrc and kept hidden until requested.
# The event watcher is a separate hidden item; the popup belongs to the mode
# indicator, so always target that parent explicitly.
item="aerospace_mode"

# Dismiss when the pointer leaves the bar or popup. This is handled before any
# row rendering so changing monitors cannot leave a stale empty popup behind.
if [[ "${SENDER:-}" == "mouse.exited.global" ]]; then
  sketchybar --set "$item" popup.drawing=off
  exit 0
fi

mode="$(aerospace list-modes --current 2>/dev/null || printf 'main')"

# When dismissing, do not rebuild the popup rows first. Rebuilding visible
# children causes the native popup to re-layout, which looks like an extra
# closing animation in addition to hiding the popup itself.
popup_drawing="$(sketchybar --query "$item" | awk '
  /"popup":/ { in_popup=1; next }
  in_popup && /"drawing":/ { print; exit }
')"
if [[ "$popup_drawing" == *'"on"'* ]]; then
  sketchybar --set "$item" popup.drawing=off
  exit 0
fi

case "$mode" in
  agent)
    keys=("1–9" "C" "Esc")
    labels=("Focus coding-agent pane" "Open ChatGPT" "Return to main mode")
    ;;
  window)
    keys=("H/J/K/L" "⇧H/J/K/L" "⌃H/J/K/L" "− / =" "/" "," "F" "R" "Tab" "1–9" "⇧1–9" "B" "Esc")
    labels=("Focus adjacent window" "Move window" "Join with neighbor" "Resize" "Tiles layout" "Accordion layout" "Float / tile" "Flatten layout" "Previous workspace" "Switch workspace" "Move window and follow" "Reload SketchyBar" "Return to main mode")
    ;;
  *)
    mode="main"
    keys=("✦ T" "✦ B" "✦ D" "✦ M" "✦ V" "✦ S" "✦ P" "✦ F" "✦ R" "✦ G" "✦ Q" "✦ L" "✦ O" "✦ C" "✦ Y" "✦ A" "✦ W" "✦ 1–9")
    labels=("Ghostty" "Google Chrome" "Discord" "Messages" "Visual Studio Code" "System Settings" "Bitwarden" "Finder" "Preview" "Coding-agent menu" "Waiting-agent menu" "Slack" "Microsoft Outlook" "Microsoft Teams" "Organize work apps" "Enter agent mode" "Enter window mode" "Switch workspace")
    ;;
esac

# Hide all rows before showing the rows for the active mode.
for i in $(seq 1 18); do
  sketchybar --set "aerospace_cheatsheet.$i" drawing=off
done

for i in "${!keys[@]}"; do
  row="aerospace_cheatsheet.$((i + 1))"
  click_script="$CONFIG_DIR/plugins/aerospace_cheatsheet_action.sh $mode $i"
  # The compact 1–9 row is informational; it does not represent one
  # particular workspace, so leave that row non-clickable.
  [[ "$mode" == "main" && "$i" -eq 17 ]] && click_script=""
  sketchybar --set "$row" \
    drawing=on \
    icon="${keys[$i]}" \
    label="${labels[$i]}" \
    click_script="$click_script"
done

# SketchyBar normally animates popup visibility changes. A zero-duration
# animation keeps the cheatsheet responsive, especially when dismissing it.
sketchybar --animate linear 0 --set "$item" popup.drawing=toggle
