# AeroSpace experiment

This is a deliberately conservative starting point for trying AeroSpace without replacing the current Raycast setup immediately.

## Try it

```sh
brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew trust --formula FelixKratz/formulae/sketchybar
brew install sketchybar borders
stow aerospace sketchybar borders
brew services start sketchybar
open -a AeroSpace
```

Grant AeroSpace the macOS Accessibility permission when prompted. The configuration enables `start-at-login`; set it to `false` in `aerospace/.config/aerospace/aerospace.toml` if you want to keep startup manual.

AeroSpace also accepts the stowed XDG path at `~/.config/aerospace/aerospace.toml`. Make sure `~/.aerospace.toml` does not also exist, because AeroSpace reports multiple configs as ambiguous.

## SketchyBar status

The stowed SketchyBar configuration runs on all connected displays and updates its Catppuccin-inspired light and dark palettes in place with the macOS appearance, without reloading the bar. Its quiet floating treatment uses neutral translucent surfaces with three-pixel outlines using JankyBorders' unfocused-window color, while reserving accent colors for active state, activity, and warnings. A shared left capsule contains the Apple menu, populated AeroSpace workspaces, and the active application with a Nerd Font application glyph. The focused workspace remains visible even when empty, and a divider separates workspaces 1–5 from 6–9. Click a workspace number to switch to it. A fixed mode slot in the workspace pill shows a green dot normally, a blue robot in agent mode, and a red window icon in window-management mode, without shifting the layout. The right side groups coding-agent state, battery, volume, date, and time in one shared capsule; the focused agent's status glyph is replaced by its circled one-based switcher index so it remains visible in the stable pane order; a Time Machine progress pill appears only while a backup is running, an Offline warning appears when neither Wi-Fi nor Ethernet is active, and microphone/camera pills appear only while those devices are in use. Agent state is pushed to SketchyBar by the generic `@coding-agents-tmux-notify-command` hook rather than polled. Clicking it focuses workspace 2 and opens the agent chooser in the most recently active attached tmux client. Click volume to mute or unmute and scroll it to adjust the level. Battery and Offline open their System Settings pages, the date toggles a mini calendar, and the time opens macOS Notification Center. The Notification Center action uses UI scripting and requires Accessibility access for SketchyBar in System Settings. The Homebrew service starts the bar at login, while AeroSpace's startup command is a safe fallback and its custom event keeps the workspace state up to date.

The muted Apple logo at the far left opens a short system menu for About This Mac, System Settings, Activity Monitor, and locking. Clicking the current-application section opens shortcuts for a new window, application settings, hiding, and quitting; these send the standard macOS Command-key shortcuts to the frontmost application and require Accessibility access for SketchyBar. The coding-agent capsule opens an indexed details popup with agent type, project, state, focused-pane highlighting, direct pane switching, and a link to the full chooser. Both popups dismiss when the pointer leaves them.

The agent status and launcher require a version of `coding-agents-tmux` that supports `status --summary --json`, `popup --client auto`, and `@coding-agents-tmux-notify-command`. Until that version is installed, the status item stays hidden. The status plugin finds Node in common Homebrew, Vite+, and nvm locations because the SketchyBar service does not inherit the interactive shell's PATH; set `CODING_AGENTS_TMUX_NODE_BIN` in the service environment to override that discovery.

After changing the bar configuration, reload it with:

```sh
sketchybar --reload
```

SketchyBar detects an existing process, so the Homebrew service and AeroSpace startup fallback will not create duplicate bars.

## Bindings

The programmable keyboard supplies Hyper as Command+Option+Control+Shift.

| Shortcut | Action |
| --- | --- |
| Hyper+T | Ghostty |
| Hyper+B | Google Chrome |
| Hyper+D | Discord |
| Hyper+M | Messages |
| Hyper+V | Visual Studio Code |
| Hyper+A | Enter agent mode |
| Hyper+S | System Settings |
| Hyper+P | Bitwarden |
| Hyper+F | Finder |
| Hyper+R | Preview |
| Hyper+G | Focus Ghostty and open the compact coding-agent menu |
| Hyper+Q | Focus Ghostty and open the compact menu for agents waiting for input |
| Hyper+L | Slack |
| Hyper+O | Microsoft Outlook |
| Hyper+C | Microsoft Teams |
| Hyper+Y | Move open work apps to workspace 6 |
| Hyper+1…9 | Switch workspace |
| Hyper+W | Enter window-management mode |

In agent mode:

- `1…9` focuses Ghostty and switches to that one-based coding-agent pane in the plugin's stable target order.
- `C` opens ChatGPT.
- `Escape` returns to normal bindings.

The mode remains active after switching or opening ChatGPT, so several agent panes can be visited in succession without pressing Hyper+A again.

In window-management mode:

- `H/J/K/L` focuses adjacent windows.
- `Shift+H/J/K/L` rearranges the focused window.
- `Control+H/J/K/L` joins the focused window with its neighbor in that direction, creating a nested container.
- `-` and `=` resize.
- `/` switches the workspace root to tiles and changes its orientation; `,` switches it to accordion.
- `F` toggles the focused window between floating and tiled.
- `R` flattens the current workspace layout.
- `Tab` switches to the previous workspace.
- `1…9` switches workspace; `Shift+1…9` moves the focused window there and follows it.
- `Escape` returns to normal bindings.

## Workspace and layout behavior

- Accordion is the default layout, with a fixed horizontal orientation and `accordion-padding = 0`, so adjacent windows do not remain visible at the left and right edges.
- Workspaces 1–5 are assigned to the macOS main display.
- Workspaces 6–9 use the secondary display when exactly two displays are attached and fall back to the main display otherwise.
- New Chrome windows move to workspace 1; Ghostty windows move to 2; Discord, Messages, and ChatGPT windows move to 3; and Slack windows move to 6.
- Outlook and Teams are not routed by `on-window-detected`, so reminder and meeting windows stay where macOS opens them. Already-open Slack, Outlook, and Teams windows are reconciled to workspace 6 at AeroSpace startup; Hyper+Y runs that reconciliation manually.
- Apps without a routing rule, including Finder and Preview, open in the current workspace.
- Inner gaps are 14 pixels and outer gaps are 8 pixels. Because SketchyBar draws on all displays, every display reserves top space for the bar: the built-in display (matched by name) uses a 14-pixel top gap because its notch makes the native menu bar taller, while any other display uses a 48-pixel top gap (the fallback).
- `on-focused-monitor-changed` moves the mouse to the lazy center of the newly focused monitor so the pointer follows focus across displays.

## Window borders

[JankyBorders](https://github.com/FelixKratz/JankyBorders) draws a colored border around the focused window. AeroSpace launches the `borders` daemon at startup, and its styling lives in the stowed `borders/.config/borders/bordersrc`. The border colors track the macOS appearance, mirroring SketchyBar's Catppuccin palette: the active border uses the accent blue and the inactive border uses a muted gray, with distinct light and dark values. Live theme switching is handled by SketchyBar's `appearance.sh` plugin, which re-applies the border colors whenever macOS toggles between light and dark. Adjust the startup colors in `bordersrc` and the on-switch colors (`BLUE` and `BORDER_INACTIVE`) in `appearance.sh`.

## Useful tuning points

- Change the app letters or remove the work-app bindings.
- Increase `accordion-padding` if you want visual hints for adjacent windows.
- Adjust the `on-window-detected` rules as the workspace assignments evolve.

To back out, quit AeroSpace, SketchyBar, and `borders`, then run `stow -D aerospace sketchybar borders` from the repository.
