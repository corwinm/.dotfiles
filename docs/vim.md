# Optional Vim fallback

`vim/.vimrc` is a standalone config for machines where Neovim is unavailable.
It uses Vim's own features and bundled runtime, with no plugin manager, downloads,
external search tools, or special fonts. Use a regular Vim build; stripped-down
`vi`/`vim-tiny` installations may lack features or the bundled netrw file browser.

Try it without installing anything (from this repository):

```sh
vim -u "$PWD/vim/.vimrc" path/to/file
```

To install it alongside the other dotfiles, run `stow vim`. Stow is optional:
you can instead copy just `vim/.vimrc` to `~/.vimrc` on another machine. Back up
any existing `~/.vimrc` before replacing it. Neovim continues using its own config.

The defaults mirror your Neovim setup: Space leader, absolute and relative line
numbers, four-column tabs, smart-case search, wrapped-line movement, centered
search/scrolling, and splits opening below/right. Syntax highlighting and
filetype indentation come from Vim's runtime. Whitespace markers use ASCII.
Netrw also shows absolute and relative line numbers.
Inactive numbers are gray; the current line number is bold and brighter (darker
on light backgrounds), inspired by your Neovim Catppuccin theme. These overrides
remain in place when switching color schemes. Basic terminals use their own
gray/white/black palette; GUI or true-color Vim uses the specified RGB colors.
The active line has a subtle gray background instead of an underline, adjusted
for dark or light backgrounds. In compatible terminals, the cursor is a steady
block in normal mode, a vertical bar in insert mode, and an underline in replace
mode. On exit, Vim asks the terminal to restore its default cursor shape.

## Compare bundled colors

Type `:colorscheme ` followed by Tab to cycle through the themes installed with
that machine's Vim. Try `:colorscheme habamax` for muted dark colors (on newer
Vim installations), `:colorscheme desert` for warmer colors, or
`:colorscheme evening` for another dark option. For a light theme, try
`:colorscheme peachpuff`. `:colorscheme default` restores Vim's default scheme.
Use `:set background=dark` or `:set background=light` to match your terminal.
These commands are temporary; add your chosen `colorscheme` command to the
vimrc to keep it. No theme is required by this config.

To compare each theme's original line-number colors too, run
`:autocmd! fallback_line_numbers` before switching themes. Restart Vim to restore
the custom line-number and active-line colors.

## Keybindings

| Keys | Action |
| --- | --- |
| `Space w` | Save |
| `Esc` | Clear search highlighting |
| `Ctrl-h/j/k/l` | Navigate Vim splits |
| `Ctrl-\` | Previous Vim window |
| `-` | Browse the current file's directory with netrw; Enter opens, `-` goes up |
| `Space sf` | Start `:find`; type a filename and use Tab to complete below the working directory |
| `Space Space` | List buffers, then enter a buffer number/name |
| `Space y` / `Space Y` | Yank motion/selection or line to the clipboard when supported, otherwise Vim's register |
| `Space d` | Delete a motion/selection without replacing the yank register |
| Visual `J` / `K` | Move selected lines down/up |

For completion in insert mode, use `Ctrl-n`/`Ctrl-p` for words and `Ctrl-x Ctrl-f`
for filenames. Use `/pattern` to search the current file. To search several files
without an external program, use `:vimgrep /pattern/gj **/*.txt` (adjust the glob),
then `:copen`, `:cnext`, and `:cprevious`. File completion/search starts at Vim's
working directory (`:pwd`); use `:cd path` to narrow it on large trees.

Clipboard access depends on Vim's build and the host session; this config does
not install a clipboard provider or forward the clipboard over SSH. Split
navigation stays within Vim. The fallback omits LSP, fuzzy pickers, Git plugins,
automatic formatting, and the Neovim theme. Spell checking is opt-in with
`:set spell` if the host already has spell files. Undo uses Vim's normal
in-session history.
