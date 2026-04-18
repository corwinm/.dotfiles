local gh = require('utils').gh

vim.pack.add({ {
  src = gh 'ThePrimeagen/harpoon',
  version = 'harpoon2',
} }, { load = false })

---@class HarpoonList
---@field add fun(self: HarpoonList, item?: any): HarpoonList
---@field select fun(self: HarpoonList, index: integer, options?: any)

---@class HarpoonUI
---@field toggle_quick_menu fun(self: HarpoonUI, list: HarpoonList, opts?: any)

---@class Harpoon
---@field ui HarpoonUI
---@field setup fun(self: Harpoon, partial_config?: table): Harpoon
---@field extend fun(self: Harpoon, extension: table)
---@field list fun(self: Harpoon, name?: string): HarpoonList

---@type Harpoon?
local harpoon = nil

---@return Harpoon
local function lazy_harpoon()
  if harpoon then return harpoon end
  vim.cmd.packadd 'harpoon'
  ---@type Harpoon
  local harpoon_module = require 'harpoon'
  harpoon_module:setup {}

  -- auto-save and harpoon list don't get along
  harpoon_module:extend {
    UI_CREATE = function() require('auto-save').off() end,
    SELECT = function() require('auto-save').on() end,
  }
  harpoon = harpoon_module
  return harpoon
end

vim.keymap.set('n', '<m-h><m-i>', function() lazy_harpoon():list():add() end, { desc = 'Harpoon add file' })

vim.keymap.set('n', '<m-h><m-l>', function() lazy_harpoon().ui:toggle_quick_menu(lazy_harpoon():list()) end, { desc = 'Harpoon [l]ist' })

-- Set <space>1..<space>5 be my shortcuts to moving to the files
for _, idx in ipairs { 1, 2, 3, 4, 5 } do
  vim.keymap.set('n', string.format('<m-%d>', idx), function() lazy_harpoon():list():select(idx) end, { desc = string.format('Harpoon select file %d', idx) })
end
