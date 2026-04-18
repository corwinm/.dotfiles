# AGENTS.md

This repo is a Neovim configuration based on kickstart.nvim. Keep changes small and consistent with the surrounding code.

## Repo-specific notes

- Most core configuration lives in `init.lua`.
- Add new plugins in `plugin/<name>.lua`.
- Put server-specific LSP overrides in `lsp/<server>.lua`.
- Put always-loaded startup logic in `plugin/<name>.lua`.
- Follow `.stylua.toml` and nearby code for Lua style.

## Validation

- Run `stylua --check .` after Lua edits.
- There is no automated test suite; validate by opening Neovim, running `:checkhealth`, and exercising the changed feature.
