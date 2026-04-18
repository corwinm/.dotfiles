local gh = require('utils').gh

vim.pack.add({ gh 'MeanderingProgrammer/render-markdown.nvim' }, { load = false })

local did_setup = false

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.cmd.packadd 'render-markdown.nvim'

    if did_setup then return end
    did_setup = true

    require('render-markdown').setup {
      file_types = { 'markdown' },
      latex = { enabled = false },
    }
  end,
})
