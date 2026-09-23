#!/usr/bin/env bash

# Work around SketchyBar's window vanishing after sleep or a screen-saver
# unlock (FelixKratz/SketchyBar#430, #497, #512). The process stays alive but
# the bar window is no longer composited; `hidden=off` does not help, while
# re-assigning the display target forces the window to be recreated.
case "${SENDER:-}" in
  system_woke | screen_unlocked | display_change) ;;
  *) exit 0 ;;
esac

log_file="${TMPDIR:-/tmp}/sketchybar-wake.log"
pid_file="${TMPDIR:-/tmp}/sketchybar-wake.pid"
log() { printf '%s [%s] %s\n' "$(date '+%F %T')" "$$" "$*" >>"$log_file"; }

# WindowServer reconfigures displays several seconds after unlock, and each
# change emits more events. Keep only the newest recovery run so the retry
# schedule always starts from the most recent event.
if [[ -f "$pid_file" ]]; then
  old_pid="$(<"$pid_file")"
  [[ "$old_pid" != "$$" ]] && kill "$old_pid" 2>/dev/null
fi
echo "$$" >"$pid_file"
log "event=$SENDER"

elapsed=0
for at in 1 3 6 10 20; do
  sleep $((at - elapsed))
  elapsed=$at
  sketchybar --bar display=main
  sketchybar --bar display=all
  log "reasserted bar at +${at}s"
done

sketchybar --update
[[ "$(<"$pid_file")" == "$$" ]] && rm -f "$pid_file"
