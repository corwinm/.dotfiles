local utils = require 'utils'
local gh = utils.gh
local pack_command = utils.pack_command
local registerKeymaps = utils.registerKeymaps

pack_command({ src = gh 'folke/trouble.nvim' }, 'Trouble', {
  command_opts = {
    nargs = '*',
    complete = function() return { 'diagnostics', 'symbols', 'lsp', 'loclist', 'qflist' } end,
  },
  setup = function()
    require('trouble').setup {}
  end,
})

registerKeymaps {
  {
    '<leader>xx',
    '<cmd>Trouble diagnostics toggle<cr>',
    desc = 'Diagnostics (Trouble)',
  },
  {
    '<leader>xX',
    '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
    desc = 'Buffer Diagnostics (Trouble)',
  },
  {
    '<leader>cs',
    '<cmd>Trouble symbols toggle focus=false<cr>',
    desc = 'Symbols (Trouble)',
  },
  {
    '<leader>cl',
    '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
    desc = 'LSP Definitions / references / ... (Trouble)',
  },
  {
    '<leader>xL',
    '<cmd>Trouble loclist toggle<cr>',
    desc = 'Location List (Trouble)',
  },
  {
    '<leader>xQ',
    '<cmd>Trouble qflist toggle<cr>',
    desc = 'Quickfix List (Trouble)',
  },
}
