vim.pack.add {
  'https://github.com/christoomey/vim-tmux-navigator',
}

vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { silent = true })
vim.keymap.set('n', '<C-\\>', '<Cmd>TmuxNavigatePrevious<CR>', { silent = true })
