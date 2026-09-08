#!/usr/bin/env bash

item="${NAME:-volume}"

case "${SENDER:-}" in
  mouse.clicked)
    osascript -e 'set volume output muted not (output muted of (get volume settings))' >/dev/null
    ;;
  mouse.scrolled)
    current="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
    next="$(awk -v current="${current:-0}" -v delta="${SCROLL_DELTA:-0}" 'BEGIN {
      value = current + delta * 5
      if (value < 0) value = 0
      if (value > 100) value = 100
      printf "%.0f", value
    }')"
    osascript -e 'set volume output muted false' -e "set volume output volume $next" >/dev/null
    ;;
esac

if [[ "${SENDER:-}" == "volume_change" && "${INFO:-}" =~ ^[0-9]+$ ]]; then
  volume="$INFO"
else
  volume="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi
muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

# HDMI and other externally controlled outputs report "missing value" because
# macOS cannot adjust their volume. Hide the control until a controllable output
# becomes active again.
if ! [[ "$volume" =~ ^[0-9]+$ ]] || [[ "$muted" != "true" && "$muted" != "false" ]]; then
  sketchybar --set "$item" drawing=off
  exit 0
fi

if [[ "$muted" == "true" ]]; then
  icon="󰝟"
  label="Muted"
elif [[ "$volume" -eq 0 ]]; then
  icon="󰝟"
  label="0%"
elif [[ "$volume" -lt 35 ]]; then
  icon="󰕿"
  label="${volume}%"
elif [[ "$volume" -lt 70 ]]; then
  icon="󰖀"
  label="${volume}%"
else
  icon="󰕾"
  label="${volume}%"
fi

sketchybar --set "$item" drawing=on icon="$icon" label="$label"
