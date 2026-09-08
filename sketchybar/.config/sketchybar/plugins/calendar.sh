#!/usr/bin/env bash

# SketchyBar has no desktop-wide click event. Closing when the pointer leaves
# the bar or popup gives the expected click-outside behavior.
if [[ "${SENDER:-}" == "mouse.exited.global" ]]; then
  sketchybar --set date popup.drawing=off
  exit 0
fi

state_dir="${TMPDIR:-/tmp}/sketchybar-calendar"
state_file="$state_dir/month-offset"
scroll_file="$state_dir/last-scroll-ms"
lock_dir="$state_dir/render.lock"
mkdir -p "$state_dir"

# Trackpad momentum can start several plugin processes at once. Serialize them
# so rows from different months can never be interleaved.
mkdir "$lock_dir" 2>/dev/null || exit 0
trap 'rmdir "$lock_dir" 2>/dev/null' EXIT

offset=0
[[ -f "$state_file" ]] && read -r offset < "$state_file"
[[ "$offset" =~ ^-?[0-9]+$ ]] || offset=0

action="${1:-render}"
# Opening the calendar always starts on the current month.
[[ "$action" == "toggle" ]] && offset=0

if [[ "${SENDER:-}" == "mouse.scrolled" ]]; then
  delta="${SCROLL_DELTA:-0}"

  # Ignore zero-delta touchpad events rather than treating them as forward.
  if awk -v delta="$delta" 'BEGIN { exit !(delta > 0) }'; then
    action=previous
  elif awk -v delta="$delta" 'BEGIN { exit !(delta < 0) }'; then
    action=next
  else
    exit 0
  fi

  # Coalesce trackpad momentum into at most one month change every 200ms.
  now_ms="$(perl -MTime::HiRes=time -e 'printf "%.0f", time() * 1000')"
  last_ms=0
  [[ -f "$scroll_file" ]] && read -r last_ms < "$scroll_file"
  [[ "$last_ms" =~ ^[0-9]+$ ]] || last_ms=0
  (( now_ms - last_ms < 200 )) && exit 0
  printf '%s\n' "$now_ms" > "$scroll_file"
fi

case "$action" in
  previous) ((offset -= 1)) ;;
  next)     ((offset += 1)) ;;
  today)    offset=0 ;;
esac
printf '%s\n' "$offset" > "$state_file"

if (( offset >= 0 )); then
  month_and_year="$(date -v+"${offset}"m '+%m %Y')"
else
  month_and_year="$(date -v"${offset}"m '+%m %Y')"
fi
read -r month year <<< "$month_and_year"
month_title="$(date -j -f '%m %Y' "$month $year" '+%B %Y')"

today="$(date '+%-d')"
current_month="$(date '+%m')"
current_year="$(date '+%Y')"
if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark$'; then
  title_color=0xffd3cdc5
  day_color=0xffffffff
  today_color=0xffd7448a
else
  title_color=0xff5c5f77
  day_color=0xff4c4f69
  today_color=0xffea76cb
fi
args=(--set calendar.0 label="$month_title" label.align=center label.color="$title_color")
row=1

# cal's own month heading is replaced by the title above.
while IFS= read -r line && (( row < 8 )); do
  color="$day_color"

  # BSD cal pads every line with two trailing spaces. Remove that padding so
  # the visible 20-column grid is genuinely centered in the popup.
  line="${line%  }"

  if [[ "$month" == "$current_month" && "$year" == "$current_year" && $row -ge 2 ]]; then
    if awk -v line="$line" -v today="$today" 'BEGIN {
      count = split(line, days, / +/)
      for (i = 1; i <= count; i++) if (days[i] == today) exit 0
      exit 1
    }'; then
      color="$today_color"
    fi
  fi

  drawing=on
  [[ -z "${line// /}" ]] && drawing=off
  args+=(--set "calendar.$row" drawing="$drawing" label="$line" label.color="$color")
  ((row += 1))
done < <(cal "$month" "$year" | tail -n +2)

while (( row < 8 )); do
  args+=(--set "calendar.$row" drawing=off label="" label.color="$day_color")
  ((row += 1))
done

[[ "$action" == "toggle" ]] && args+=(--set date popup.drawing=toggle)
sketchybar "${args[@]}"
