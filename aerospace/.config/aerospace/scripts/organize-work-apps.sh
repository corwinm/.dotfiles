#!/bin/bash

# Move already-open work applications to workspace 6 without affecting newly
# opened reminder, meeting, or other auxiliary windows.
set -u

workspace="${AEROSPACE_WORK_APPS_WORKSPACE:-6}"
apps=(
  com.tinyspeck.slackmacgap
  com.microsoft.Outlook
  com.microsoft.teams2
)

for app_id in "${apps[@]}"; do
  aerospace list-windows --monitor all --app-bundle-id "$app_id" --format '%{window-id}' 2>/dev/null |
    while IFS= read -r window_id; do
      [[ -n "$window_id" ]] || continue
      aerospace move-node-to-workspace --window-id "$window_id" "$workspace" 2>/dev/null || true
    done
done
