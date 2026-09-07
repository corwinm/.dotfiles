#!/usr/bin/env bash

item="${NAME:-front_app}"
app="${INFO:-$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)}"

sketchybar --set "$item" label="${app:-Desktop}"
