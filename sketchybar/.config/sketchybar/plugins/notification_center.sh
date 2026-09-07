#!/usr/bin/env bash

# The Notification Center panel is the native clock menu-bar item's popover.
# UI scripting is required because macOS exposes no public command to toggle it.
osascript <<'APPLESCRIPT'
tell application "System Events"
  tell process "ControlCenter"
    repeat with menuItem in menu bar items of menu bar 1
      try
        set itemDescription to description of menuItem as text
        set itemTitle to title of menuItem as text
        if itemDescription contains "Clock" or itemDescription contains "Date" or itemTitle contains "Clock" then
          perform action "AXPress" of menuItem
          return
        end if
      end try
    end repeat

    -- The clock is normally the first Control Center menu-bar item.
    perform action "AXPress" of menu bar item 1 of menu bar 1
  end tell
end tell
APPLESCRIPT
