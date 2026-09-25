#!/usr/bin/env bash

set -u

mode="${1:-main}"
index="${2:--1}"

# Clicking a row should behave like using the shortcut: dismiss first.
sketchybar --set aerospace_mode popup.drawing=off

case "$mode:$index" in
  main:0) open -a "Ghostty" ;;
  main:1) open -a "Google Chrome" ;;
  main:2) open -a "Discord" ;;
  main:3) open -a "Messages" ;;
  main:4) open -a "Visual Studio Code" ;;
  main:5) open -a "System Settings" ;;
  main:6) open -a "Bitwarden" ;;
  main:7) open -a "Finder" ;;
  main:8) open -a "Preview" ;;
  main:9) CODING_AGENTS_TMUX_FOCUS_COMMAND="open -a Ghostty" exec "$HOME/.tmux/plugins/coding-agents-tmux/integrations/external/focus-and-popup.sh" --menu ;;
  main:10) CODING_AGENTS_TMUX_FOCUS_COMMAND="open -a Ghostty" exec "$HOME/.tmux/plugins/coding-agents-tmux/integrations/external/focus-and-popup.sh" --menu --waiting ;;
  main:11) open -a "Slack" ;;
  main:12) open -a "Microsoft Outlook" ;;
  main:13) open -a "Microsoft Teams" ;;
  main:14) "$HOME/.config/aerospace/scripts/organize-work-apps.sh" ;;
  main:15) aerospace mode agent; sketchybar --trigger aerospace_mode_change MODE=agent ;;
  main:16) aerospace mode window; sketchybar --trigger aerospace_mode_change MODE=window ;;
  main:17) aerospace workspace 1 ;;
  agent:0) "$HOME/.tmux/plugins/coding-agents-tmux/integrations/external/focus-and-switch-index.sh" 1 ;;
  agent:1) open -a "ChatGPT" ;;
  agent:2) aerospace mode main; sketchybar --trigger aerospace_mode_change MODE=main ;;
  window:0) aerospace focus left ;;
  window:1) aerospace move left ;;
  window:2) aerospace join-with left ;;
  window:3) aerospace resize smart -50 ;;
  window:4) aerospace layout --root tiles horizontal vertical ;;
  window:5) aerospace layout --root accordion horizontal vertical ;;
  window:6) aerospace layout floating tiling ;;
  window:7) aerospace flatten-workspace-tree ;;
  window:8) aerospace workspace-back-and-forth ;;
  window:11) sketchybar --reload ;;
  window:12) aerospace mode main; sketchybar --trigger aerospace_mode_change MODE=main ;;
  *) printf 'No action configured for %s:%s\n' "$mode" "$index" >&2; exit 1 ;;
esac
