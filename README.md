# .dotfiles

Init git submodules:

```sh
git submodule update --init --recursive
```

Update git to always pull submodules

```sh
git config submodule.recurse true
```

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
sudo apt install stow
```

Run `stow` for all dotfiles:

```sh
stow zsh
stow tmux
stow nvim
stow sesh
stow wezterm
stow ghostty
```

