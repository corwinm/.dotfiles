vim.pack.add {
  'https://github.com/pmizio/typescript-tools.nvim',
}
require('typescript-tools').setup {
  single_file_support = false,
  root_dir = require('lspconfig').util.root_pattern 'package.json',
}
