#!/usr/bin/env bash

# Work around SketchyBar's window vanishing after sleep or a screen-saver
# unlock (FelixKratz/SketchyBar#430, #497, #512). The process stays alive but
# the bar window is no longer composited; `hidden=off` does not help, while
# re-assigning the display target forces the window to be recreated.
case "${SENDER:-}" in
  system_woke | screen_unlocked) ;;
  *) exit 0 ;;
esac

# Displays and the login window settle asynchronously; retry once in case the
# first attempt lands before WindowServer is ready.
for delay in 1 3; do
  sleep "$delay"
  sketchybar --bar display=main
  sketchybar --bar display=all
done

sketchybar --update
