-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format { async = false }
  end,
})

local function pack_prune_candidates()
  local candidates = vim.iter(vim.pack.get())
    :filter(function(plugin) return not plugin.active end)
    :map(function(plugin)
      return {
        name = plugin.spec.name,
        src = plugin.spec.src,
        path = plugin.path,
      }
    end)
    :totable()

  table.sort(candidates, function(a, b) return a.name < b.name end)

  return candidates
end

local function delete_pack_plugins(names)
  if #names == 0 then return end

  vim.pack.del(names)
  vim.notify(('Deleted vim.pack plugins: %s'):format(table.concat(names, ', ')), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('PackPrune', function()
  local candidates = pack_prune_candidates()

  if #candidates == 0 then
    vim.notify('No inactive vim.pack plugin candidates found', vim.log.levels.INFO)
    return
  end

  while #candidates > 0 do
    local menu = {
      'PackPrune candidates:',
      '1. Cancel',
      '2. Delete all listed below',
    }

    for i, candidate in ipairs(candidates) do
      local detail = candidate.src or candidate.path or 'unknown source'
      menu[#menu + 1] = ('%d. %s — %s'):format(i + 2, candidate.name, detail)
    end

    local choice = vim.fn.inputlist(menu)

    if choice <= 0 or choice == 1 then return end

    if choice == 2 then
      local names = vim.tbl_map(function(candidate) return candidate.name end, candidates)
      local confirm = vim.fn.confirm(
        ('Delete %d vim.pack candidate(s)?\n\n%s\n\nReview carefully: lazy plugins can appear here before they are added in the current session.')
          :format(#names, table.concat(names, ', ')),
        '&Delete\n&Cancel',
        2
      )

      if confirm == 1 then delete_pack_plugins(names) end
      return
    end

    local candidate = candidates[choice - 2]
    if candidate then
      local confirm = vim.fn.confirm(
        ('Delete %s?\n\nsrc: %s\npath: %s\n\nReview carefully: lazy plugins can appear here before they are added in the current session.')
          :format(candidate.name, candidate.src or 'unknown', candidate.path or 'unknown'),
        '&Delete\n&Keep',
        2
      )

      if confirm == 1 then
        delete_pack_plugins { candidate.name }
        table.remove(candidates, choice - 2)
      end
    end
  end
end, {
  desc = 'Interactively delete inactive vim.pack plugin candidates from disk',
})

vim.api.nvim_create_user_command('PackPruneAll', function()
  local candidates = pack_prune_candidates()

  if #candidates == 0 then
    vim.notify('No inactive vim.pack plugin candidates found', vim.log.levels.INFO)
    return
  end

  local names = vim.tbl_map(function(candidate) return candidate.name end, candidates)
  local confirm = vim.fn.confirm(
    ('Delete all inactive vim.pack plugin candidates?\n\n%s\n\nReview carefully: lazy plugins can appear here before they are added in the current session.')
      :format(table.concat(names, ', ')),
    '&Delete\n&Cancel',
    2
  )

  if confirm == 1 then delete_pack_plugins(names) end
end, {
  desc = 'Delete all inactive vim.pack plugin candidates from disk',
})
