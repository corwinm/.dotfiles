local gh = require('utils').gh

vim.pack.add({
  gh 'ray-x/guihua.lua',
  gh 'ray-x/go.nvim',
}, { load = false })

local did_setup = false

local function setup_go()
  if did_setup then return end
  did_setup = true

  require('go').setup()
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod' },
  callback = function()
    vim.cmd.packadd 'guihua.lua'
    vim.cmd.packadd 'go.nvim'
    setup_go()
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  callback = function()
    vim.cmd.packadd 'guihua.lua'
    vim.cmd.packadd 'go.nvim'
    setup_go()
  end,
})
