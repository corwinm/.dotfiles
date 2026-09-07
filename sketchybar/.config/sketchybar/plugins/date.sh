#!/usr/bin/env bash

item="${NAME:-date}"
sketchybar --set "$item" label="$(date '+%a %b %d')"
