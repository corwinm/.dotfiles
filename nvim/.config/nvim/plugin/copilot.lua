vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    -- Load the Copilot plugin lazily when entering insert mode for the first time
    vim.pack.add {
      {
        src = 'https://github.com/zbirenbaum/copilot.lua',
        cmd = 'Copilot',
      },
    }

    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
    }

    vim.keymap.set('i', '<Tab>', function()
      if require('copilot.suggestion').is_visible() then
        require('copilot.suggestion').accept()
      else
        -- Fallback to default Tab behavior (e.g., indentation)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
      end
    end, { silent = true })
  end,
})
