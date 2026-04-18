local ts_spec = {
  src = 'https://github.com/pmizio/typescript-tools.nvim',
  name = 'typescript-tools.nvim',
}

vim.pack.add({ ts_spec }, { load = false })

local did_setup = false

local function setup_typescript_tools()
  if did_setup then return end
  did_setup = true

  require('typescript-tools').setup {
    single_file_support = false,
    root_dir = require('lspconfig').util.root_pattern 'package.json',
  }
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  once = true,
  callback = function()
    vim.cmd.packadd 'typescript-tools.nvim'
    setup_typescript_tools()
  end,
})
