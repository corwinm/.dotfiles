local function format_tail(path)
  if path == '' then return '[No Name]' end
  if path == '/' then return '/' end

  return vim.fn.fnamemodify(path, ':t')
end

local function get_oil_title()
  local ok, oil = pcall(require, 'oil')
  if not ok then return 'oil://' end

  local dir = oil.get_current_dir(0)
  if not dir or dir == '' then return 'oil://' end

  dir = vim.fs.normalize(dir)
  if dir ~= '/' then dir = dir:gsub('/+$', '') end

  return 'oil://' .. format_tail(dir)
end

function _G.custom_titlestring()
  local modified = vim.bo.modified and '+ ' or ''

  if vim.bo.filetype == 'oil' then return string.format('%s%s | nvim', modified, get_oil_title()) end

  return string.format('%s%s | nvim', modified, format_tail(vim.api.nvim_buf_get_name(0)))
end

vim.o.title = true
vim.o.titlestring = '%{v:lua.custom_titlestring()}'
