# AeroSpace experiment

This is a deliberately conservative starting point for trying AeroSpace without replacing the current Raycast setup immediately.

## Try it

```sh
brew install --cask nikitabobko/tap/aerospace
stow aerospace
open -a AeroSpace
```

Grant AeroSpace the macOS Accessibility permission when prompted. `start-at-login` is initially disabled; enable it in `aerospace/.config/aerospace/aerospace.toml` only after deciding to keep the setup.

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
- `1…9` switches workspace; `Shift+1…9` moves the focused window there.
- `Escape` returns to normal bindings.

## Useful tuning points

- Change the app letters or remove the work-app bindings.
- Change the `8`-pixel inner and outer gaps or set them to `0`.
- Accordion is the default layout, with `accordion-padding = 0` so adjacent windows do not remain visible at the left and right edges. Increase the padding if you want those visual window hints.
- Add `on-window-detected` rules only after deciding which apps should always follow particular workspaces. Starting without routing makes the trial easier to understand and undo.
- Set `start-at-login = true` after the experiment becomes the preferred setup.

To back out, quit AeroSpace and run `stow -D aerospace` from the repository.
