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

Apply the preferred macOS Dock settings on a new Mac:

```sh
./scripts/macos-defaults.sh
```

The script removes the Dock's auto-hide delay, shortens its auto-hide animation, and automatically hides the native menu bar so it does not overlap SketchyBar. It restarts the affected system processes so the changes take effect immediately.
