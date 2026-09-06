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
| Hyper+S | System Settings |
| Hyper+P | Bitwarden |
| Hyper+F | Finder |
| Hyper+R | Preview |
| Hyper+L | Slack |
| Hyper+O | Microsoft Outlook |
| Hyper+C | Microsoft Teams |
| Hyper+1…9 | Switch workspace |
| Hyper+W | Enter window-management mode |

In window-management mode:

- `H/J/K/L` focuses adjacent windows.
- `Shift+H/J/K/L` rearranges the focused window.
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
- New Chrome windows move to workspace 1; Ghostty windows move to 2; Discord, Messages, and ChatGPT windows move to 3; and Slack, Outlook, and Teams windows move to 6.
- Apps without a routing rule, including Finder and Preview, open in the current workspace.
- Inner gaps remain at 8 pixels; outer screen-edge gaps are disabled.

## Useful tuning points

- Change the app letters or remove the work-app bindings.
- Increase `accordion-padding` if you want visual hints for adjacent windows.
- Adjust the `on-window-detected` rules as the workspace assignments evolve.

To back out, quit AeroSpace and run `stow -D aerospace` from the repository.
