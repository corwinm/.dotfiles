#!/usr/bin/env bash

# Restart JankyBorders to release retained CoreAnimation backing surfaces.
killall borders 2>/dev/null || true
exec borders
