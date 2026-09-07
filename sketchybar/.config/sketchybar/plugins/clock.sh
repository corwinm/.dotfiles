#!/usr/bin/env bash

item="${NAME:-time}"
sketchybar --set "$item" label="$(date '+%I:%M %p')"
