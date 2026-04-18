# Neovim Config

My personal Neovim config, originally based on `kickstart.nvim`, and open to anyone who wants to borrow pieces for their own setup.

## Highlights

- Native plugin management with `vim.pack`, plus pinned versions in `nvim-pack-lock.json`
- LSP, completion, and formatting with Mason, `nvim-lspconfig`, `blink.cmp`, and `conform.nvim`
- Core workflow built around Telescope, Treesitter, Oil, Git tooling, and Obsidian/markdown support

## Requirements

- A recent Neovim build with `vim.pack`
- `git`, `make`, `ripgrep`, and a clipboard provider
- A Nerd Font
- Optional, depending on workflow: `go`, `node`/`npm`, `lazygit`, `gh`, `kitty`, `magick`

## Install

```sh
git clone <your-repo> ~/.config/nvim
nvim
```

Plugins install on first launch.

## Layout

- `init.lua`: core plugin setup, LSP, completion, Treesitter, and editor behavior
- `lua/config/*.lua`: options, keymaps, and autocommands
- `plugin/*.lua`: plugin-specific configuration

## Validation

- `stylua --check .`
- Open `nvim`, run `:checkhealth`, and exercise the feature you changed
