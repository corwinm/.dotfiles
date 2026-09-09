#!/usr/bin/env bash

set -euo pipefail

action="${1:-toggle}"
plugin_root="${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}/coding-agents-tmux"

close_popup() {
  sketchybar --set coding-agents popup.drawing=off
}

case "$action" in
  toggle)
    sketchybar --set coding-agents popup.drawing=toggle
    ;;
  dismiss)
    close_popup
    ;;
  switch)
    index="${2:-}"
    [[ "$index" =~ ^[1-9]$ ]] || exit 2
    close_popup
    export CODING_AGENTS_TMUX_FOCUS_COMMAND='/usr/bin/open -a Ghostty'
    exec "$plugin_root/integrations/external/focus-and-switch-index.sh" "$index"
    ;;
  chooser)
    close_popup
    export CODING_AGENTS_TMUX_FOCUS_COMMAND='/usr/bin/open -a Ghostty'
    exec "$plugin_root/integrations/external/focus-and-popup.sh"
    ;;
  *)
    printf 'unknown agent menu action: %s\n' "$action" >&2
    exit 2
    ;;
esac
