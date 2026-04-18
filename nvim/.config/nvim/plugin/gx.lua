local utils = require 'utils'
local gh = utils.gh
local pack_command = utils.pack_command
local registerKeymaps = utils.registerKeymaps

vim.g.netrw_nogx = 1 -- disable netrw gx

pack_command({ src = gh 'chrishrb/gx.nvim' }, 'Browse', {
  command_opts = { nargs = '?', range = 1 },
  setup = function()
    require('gx').setup {}
  end,
  invoke = function(opts)
    local gx = require 'gx'

    if opts.args ~= '' then
      gx.open('c', opts.fargs[1])
      return
    end

    if opts.range == 2 then
      gx.open('v', vim.fn.getline(opts.line1))
      return
    end

    gx.open()
  end,
})

registerKeymaps { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } }
