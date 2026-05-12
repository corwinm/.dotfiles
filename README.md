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
```
