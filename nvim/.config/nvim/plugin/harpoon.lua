local gh = require('utils').gh

vim.pack.add { {
  src = gh 'ThePrimeagen/harpoon',
  version = 'harpoon2',
} }

local harpoon = require 'harpoon'
harpoon.setup {}

-- auto-save and harpoon list don't get along
harpoon:extend {
  UI_CREATE = function() require('auto-save').off() end,
  SELECT = function() require('auto-save').on() end,
}
vim.keymap.set('n', '<m-h><m-i>', function() harpoon:list():add() end, { desc = 'Harpoon add file' })

vim.keymap.set('n', '<m-h><m-l>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon [l]ist' })

-- Set <space>1..<space>5 be my shortcuts to moving to the files
for _, idx in ipairs { 1, 2, 3, 4, 5 } do
  vim.keymap.set('n', string.format('<m-%d>', idx), function() harpoon:list():select(idx) end, { desc = string.format('Harpoon select file %d', idx) })
end
