-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make tabs default to 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.g.skip_ts_context_commentstring_module = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
vim.keymap.set('n', '<C-h>', function()
  require('vscode').action 'workbench.action.focusLeftGroup'
end, { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-j>', function()
  require('vscode').action 'workbench.action.focusBelowGroup'
end, { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', function()
  require('vscode').action 'workbench.action.focusAboveGroup'
end, { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-l>', function()
  require('vscode').action 'workbench.action.focusRightGroup'
end, { desc = 'Move focus to the right window' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Not Sure what I like best here
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==') -- move line up(n)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==') -- move line down(n)
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv") -- move line down(v)

-- Center view when scrolling
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '*', '*zz')

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[y]ank system' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = '[Y]ank line system' })

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = '[d]elete _' })

vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite file' })

-- Code folding
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = false, silent = true })

local vscode = require 'vscode'

local function mapVSCodeCall(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, function()
    vscode.call(rhs)
  end, { silent = true, noremap = true })
end

-- Remap folding keys
mapVSCodeCall('n', '<leader>zM', 'editor.foldAll')
mapVSCodeCall('n', '<leader>zR', 'editor.unfoldAll')
mapVSCodeCall('n', '<leader>zc', 'editor.fold')
mapVSCodeCall('n', '<leader>zC', 'editor.foldRecursively')
mapVSCodeCall('n', '<leader>zo', 'editor.unfold')
mapVSCodeCall('n', '<leader>zO', 'editor.unfoldRecursively')
mapVSCodeCall('n', '<leader>za', 'editor.toggleFold')

-- Remap folding keys
mapVSCodeCall('n', 'zM', 'editor.foldAll')
mapVSCodeCall('n', 'zR', 'editor.unfoldAll')
mapVSCodeCall('n', 'zc', 'editor.fold')
mapVSCodeCall('n', 'zC', 'editor.foldRecursively')
mapVSCodeCall('n', 'zo', 'editor.unfold')
mapVSCodeCall('n', 'zO', 'editor.unfoldRecursively')
mapVSCodeCall('n', 'za', 'editor.toggleFold')

-- FindItFaster
mapVSCodeCall('n', '<leader>sf', 'find-it-faster.findFiles')
mapVSCodeCall('n', '<leader>sg', 'find-it-faster.findWithinFiles')
