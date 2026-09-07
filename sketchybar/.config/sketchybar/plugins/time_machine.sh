#!/usr/bin/env bash

item="${NAME:-time_machine}"
status="$(tmutil status 2>/dev/null)"
running="$(awk -F'= ' '/Running =/ { gsub(/[ ;]/, "", $2); print $2; exit }' <<< "$status")"

if [[ "$running" != "1" ]]; then
  sketchybar --set "$item" drawing=off
  exit 0
fi

# FractionOfProgressBar is the share assigned to the current copying phase,
# while Progress.Percent is completion within that phase. macOS combines them
# with the already-completed share: (1 - fraction) + fraction * phase.
progress="$(awk -F'= ' '
  /FractionOfProgressBar =/ {
    gsub(/[";]/, "", $2)
    fraction = $2
  }
  /^[[:space:]]*Percent =/ {
    gsub(/[";]/, "", $2)
    phase = $2
  }
  END {
    if (fraction >= 0 && fraction <= 1 && phase >= 0 && phase <= 1)
      printf "%.1f%%", ((1 - fraction) + fraction * phase) * 100
    else if (phase >= 0 && phase <= 1)
      printf "%.1f%%", phase * 100
  }
' <<< "$status")"

sketchybar --set "$item" drawing=on label="${progress:-Preparing}"
