-- Lazily load DAP on first use via debug keymaps.

local gh = require('utils').gh

local specs = {
  { src = gh 'nvim-neotest/nvim-nio', name = 'nvim-nio' },
  { src = gh 'rcarriga/nvim-dap-ui', name = 'nvim-dap-ui' },
  { src = gh 'mfussenegger/nvim-dap', name = 'nvim-dap' },
  { src = gh 'jay-babu/mason-nvim-dap.nvim', name = 'mason-nvim-dap.nvim' },
  { src = gh 'leoluz/nvim-dap-go', name = 'nvim-dap-go' },
}

vim.pack.add(specs, { load = false })

local did_setup = false

local function load_dap()
  if did_setup then return end
  did_setup = true

  vim.cmd.packadd 'nvim-dap'
  vim.cmd.packadd 'nvim-nio'
  vim.cmd.packadd 'nvim-dap-ui'
  vim.cmd.packadd 'mason-nvim-dap.nvim'
  vim.cmd.packadd 'nvim-dap-go'

  local dap = require 'dap'
  local dapui = require 'dapui'

  require('mason-nvim-dap').setup {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
      'delve',
      'js-debug-adapter',
    },
  }

  -- Dap UI setup
  -- For more information, see |:help nvim-dap-ui|
  dapui.setup {
    -- Set icons to characters that are more likely to work in every terminal.
    --    Feel free to remove or use ones that you like more! :)
    --    Don't feel like these are good choices.
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  -- Install golang specific config
  require('dap-go').setup {
    delve = {
      -- On Windows delve must be run attached or it crashes.
      -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
      detached = vim.fn.has 'win32' == 0,
    },
  }

  dap.adapters['pwa-node'] = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'js-debug-adapter',
      args = { '${port}' },
    },
  }

  local exts = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

  for _, ext in ipairs(exts) do
    dap.configurations[ext] = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (Node)',
        cwd = vim.fn.getcwd(),
        args = { '${file}' },
        sourceMaps = true,
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to Process',
        processId = require('dap.utils').pick_process,
        cwd = vim.fn.getcwd(),
      },
    }
  end
end

local function with_dap(fn)
  return function(...)
    load_dap()
    return fn(...)
  end
end

vim.keymap.set('n', '<F5>', with_dap(function() require('dap').continue() end), {
  desc = 'Debug: Start/Continue',
})

vim.keymap.set('n', '<F1>', with_dap(function() require('dap').step_into() end), {
  desc = 'Debug: Step Into',
})

vim.keymap.set('n', '<F2>', with_dap(function() require('dap').step_over() end), {
  desc = 'Debug: Step Over',
})

vim.keymap.set('n', '<F3>', with_dap(function() require('dap').step_out() end), {
  desc = 'Debug: Step Out',
})

vim.keymap.set('n', '<leader>b', with_dap(function() require('dap').toggle_breakpoint() end), {
  desc = 'Debug: Toggle Breakpoint',
})

vim.keymap.set('n', '<leader>B', with_dap(function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end), {
  desc = 'Debug: Set Breakpoint',
})

vim.keymap.set('n', '<F7>', with_dap(function() require('dapui').toggle() end), {
  desc = 'Debug: See last session result',
})
