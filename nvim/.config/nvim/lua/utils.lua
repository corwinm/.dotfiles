local M = {}

--- Convert a plugin name to a GitHub URL
--- @param plugin string
--- @return string
local function gh(plugin) return 'https://github.com/' .. plugin end
M.gh = gh

--- Register keymaps in lazy.nvim format
--- @param keymaps table[]
--- Each keymap should be a table with the following format:
--- {
---    mode = string, -- e.g., 'n', 'i', 'v',
---    lhs = string, -- e.g., '<leader>ff'
---    rhs = string|function, -- e.g., '<cmd>Telescope find_files<cr>' or a Lua function
---    desc = string, -- e.g., 'Find files with Telescope'
---    opts = table, -- Optional keymap options (e.g., { silent = true })
--- }
local function registerKeymaps(keymaps)
  for _, keymap in ipairs(keymaps) do
    -- local mode = keymap[1]
    local mode = keymap.mode or 'n'
    local lhs = keymap[1]
    local rhs = keymap[2]
    local opts = keymap[3] or {}
    local desc = keymap.desc or opts.desc
    if desc then opts.desc = desc end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
M.registerKeymaps = registerKeymaps

--- Infer a plugin name from a vim.pack spec.
--- @param spec string|table
--- @return string
local function pack_name(spec)
  if type(spec) == 'table' and spec.name then return spec.name end

  local src = type(spec) == 'table' and spec.src or spec
  local name = src:match '/([^/]+)/*$' or src

  return name:gsub('%.git$', '')
end

--- Create a command that loads an opt plugin on first use.
--- @param spec string|table
--- @param command_name string
--- @param opts? table
local function pack_command(spec, command_name, opts)
  opts = opts or {}

  local plugin_name = pack_name(spec)
  local pack_spec = type(spec) == 'table' and spec or { src = spec }
  local did_setup = false

  vim.pack.add({ pack_spec }, { load = false })

  vim.api.nvim_create_user_command(command_name, function(cmd_opts)
    if opts.replace_command ~= false then pcall(vim.api.nvim_del_user_command, command_name) end

    vim.cmd.packadd(plugin_name)

    if not did_setup then
      did_setup = true

      if opts.setup then opts.setup() end
    end

    if opts.invoke then return opts.invoke(cmd_opts) end

    local bang = cmd_opts.bang and '!' or ''
    local args = cmd_opts.args ~= '' and (' ' .. cmd_opts.args) or ''
    vim.cmd(command_name .. bang .. args)
  end, opts.command_opts or { nargs = '*', bang = true })
end
M.pack_command = pack_command

return M
