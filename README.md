# .dotfiles

Init git submodules:

```sh
git submodule update --init --recursive
```

Ensure `stow` is installed:

MacOS:

```sh
brew install stow
```

Ubuntu:

```sh
sudo apt install stow
```

Run `stow` for all dotfiles:

```sh
stow zsh
stow tmux
stow nvim
stow wezterm
stow ghostty
```

