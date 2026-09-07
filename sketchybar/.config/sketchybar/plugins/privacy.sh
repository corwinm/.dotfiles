#!/usr/bin/env bash

source_file="$CONFIG_DIR/helpers/privacy_status.swift"
cache_dir="${TMPDIR:-/tmp}/sketchybar-helpers"
helper="$cache_dir/privacy_status"
mkdir -p "$cache_dir"

if [[ ! -x "$helper" || "$source_file" -nt "$helper" ]]; then
  if ! xcrun swiftc -framework CoreAudio -framework CoreMediaIO "$source_file" -o "$helper"; then
    sketchybar --set microphone_active drawing=off --set camera_active drawing=off
    exit 0
  fi
fi

status="$($helper 2>/dev/null)"
mic=off
camera=off
[[ "$status" == *"mic=1"* ]] && mic=on
[[ "$status" == *"camera=1"* ]] && camera=on

sketchybar --set microphone_active drawing="$mic" \
           --set camera_active drawing="$camera"
