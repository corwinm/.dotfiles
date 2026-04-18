vim.pack.add { { src = 'https://github.com/stevearc/oil.nvim' } }

local oil = require 'oil'
local oil_autosave_group = vim.api.nvim_create_augroup('custom_oil_autosave', { clear = true })

local function get_float_title(winid)
  local dir = oil.get_current_dir(vim.api.nvim_win_get_buf(winid))
  if not dir or dir == '' then return 'oil://' end

  dir = vim.fs.normalize(dir)
  if dir ~= '/' then dir = dir:gsub('/+$', '') end

  return 'oil://' .. (dir == '/' and '/' or vim.fn.fnamemodify(dir, ':t'))
end

local function toggle_autosave(enabled)
  return function(args)
    if vim.bo[args.buf].filetype ~= 'oil' then return end

    require('auto-save')[enabled and 'on' or 'off']()
  end
end

oil.setup {
  columns = { 'icon' },
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['gR'] = 'actions.refresh',
    ['<M-h>'] = 'actions.select_split',
  },
  view_options = {
    show_hidden = true,
  },
  float = {
    get_win_title = get_float_title,
  },
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    enabled = true,
    timeout = 1000,
    autosave_changes = true,
  },
}

-- Open parent directory in current window with preview
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>-', oil.toggle_float, { desc = 'Open parent directory - float' })

vim.api.nvim_create_autocmd('BufEnter', {
  group = oil_autosave_group,
  callback = toggle_autosave(false),
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = oil_autosave_group,
  callback = toggle_autosave(true),
})
