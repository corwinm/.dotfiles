# .dotfiles

Ensure `stow` is installed:

MacOS:

Install everything

```sh
brew bundle
```

Or just stow

```sh
brew install stow
```

Ubuntu:

```sh
sudo apt install stow fd-find
```

Install a current version of `fzf` from git instead of Ubuntu apt, since the apt version can be too old for this zsh config:

```sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

Run `stow` for all dotfiles:

```sh
stow zsh
stow tmux
stow nvim
stow sesh
stow wezterm
stow ghostty
stow pi
# Optional AeroSpace + workspace status bar
stow aerospace
stow sketchybar
```

See [`docs/aerospace.md`](docs/aerospace.md) for the trial bindings, SketchyBar integration, and setup notes.

## macOS settings

Apply the preferred macOS Dock and menu bar settings on a new Mac:

```sh
./scripts/macos-defaults.sh
```

The script removes the Dock's auto-hide delay, shortens its auto-hide animation, and automatically hides the native menu bar so it does not overlap SketchyBar. It also requests the blurred native menu bar background for better readability when the bar is revealed and restarts the affected system processes.

On macOS Tahoe, menu bar preference files can update without the running UI applying the change. After running the script on a new Mac, open **System Settings → Menu Bar**, set **Automatically hide and show the menu bar** to **Always**, and enable **Show menu bar background**. If either setting already appears selected but has no visible effect, toggle it off and back on once.
