# AeroSpace experiment

This is a deliberately conservative starting point for trying AeroSpace without replacing the current Raycast setup immediately.

## Try it

```sh
brew install --cask nikitabobko/tap/aerospace
stow aerospace
open -a AeroSpace
```

Grant AeroSpace the macOS Accessibility permission when prompted. The configuration enables `start-at-login`; set it to `false` in `aerospace/.config/aerospace/aerospace.toml` if you want to keep startup manual.

AeroSpace also accepts the stowed XDG path at `~/.config/aerospace/aerospace.toml`. Make sure `~/.aerospace.toml` does not also exist, because AeroSpace reports multiple configs as ambiguous.

## Bindings

The programmable keyboard supplies Hyper as Command+Option+Control+Shift.

| Shortcut | Action |
| --- | --- |
| Hyper+T | Ghostty |
| Hyper+B | Google Chrome |
| Hyper+D | Discord |
| Hyper+M | Messages |
| Hyper+V | Visual Studio Code |
| Hyper+A | ChatGPT |
| Hyper+S | Slack |
| Hyper+O | Microsoft Outlook |
| Hyper+C | Microsoft Teams |
| Hyper+1…9 | Switch workspace |
| Hyper+W | Enter window-management mode |

In window-management mode:

- `H/J/K/L` focuses adjacent windows.
- `Shift+H/J/K/L` rearranges the focused window.
- `-` and `=` resize.
- `/` changes tile orientation; `,` uses accordion layout.
- `F` toggles the focused window between floating and tiled.
- `R` flattens the current workspace layout.
- `Tab` switches to the previous workspace.
- `1…9` switches workspace; `Shift+1…9` moves the focused window there and follows it.
- `Escape` returns to normal bindings.

## Workspace and layout behavior

- Accordion is the default layout, with a fixed horizontal orientation and `accordion-padding = 0`, so adjacent windows do not remain visible at the left and right edges.
- Workspaces 1–5 are assigned to the macOS main display.
- Workspaces 6–9 use the secondary display when exactly two displays are attached and fall back to the main display otherwise.
- Inner gaps remain at 8 pixels; outer screen-edge gaps are disabled.

## Useful tuning points

- Change the app letters or remove the work-app bindings.
- Increase `accordion-padding` if you want visual hints for adjacent windows.
- Add `on-window-detected` rules only after deciding which apps should always follow particular workspaces. Starting without routing makes the setup easier to understand and undo.

To back out, quit AeroSpace and run `stow -D aerospace` from the repository.
