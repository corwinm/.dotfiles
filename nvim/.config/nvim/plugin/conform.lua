local fs = require 'conform.fs'
local util = require 'conform.util'

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters = {
    oxfmt = {
      command = util.from_node_modules(fs.is_windows and 'oxfmt.cmd' or 'oxfmt'),
      args = { '--stdin-filepath', '$FILENAME' },
      cwd = util.root_file {
        '.oxfmtrc.json',
        '.oxfmtrc.jsonc',
        'oxfmt.config.ts',
        '.editorconfig',
        'package.json',
        '.git',
      },
    },
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform can also run multiple formatters sequentially
    python = { 'isort', 'black' },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
    typescript = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    javascript = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    json = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    vue = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    html = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    css = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    go = { 'goimports', 'gofumpt' },
  },
}

vim.keymap.set('n', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })
