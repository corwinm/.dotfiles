local utils = require 'utils'
local gh = utils.gh
local registerKeymaps = utils.registerKeymaps

local function with_visual_selection(callback)
  return function()
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)
    vim.schedule(callback)
  end
end

-- v2 currently ships a mismatched native generator/API here; v1.6.3 is stable.
vim.pack.add { { src = gh 'mistricky/codesnap.nvim', version = 'v1.6.3' } }

require('codesnap').setup {
  save_path = '~/Pictures',
  has_breadcrumbs = false,
  bg_theme = 'dusk',
  watermark = '',
}

registerKeymaps {
  {
    '<leader>cc',
    with_visual_selection(function() vim.cmd 'CodeSnap' end),
    mode = 'x',
    desc = 'Save selected code snapshot into clipboard',
  },
  {
    '<leader>cp',
    with_visual_selection(function() vim.cmd 'CodeSnapSave' end),
    mode = 'x',
    desc = 'Save selected code snapshot in ~/Pictures',
  },
  {
    '<leader>ci',
    with_visual_selection(function() vim.cmd 'CodeSnapASCII' end),
    mode = 'x',
    desc = 'Save selected code ASCII snapshot into clipboard',
  },
}
