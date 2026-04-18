local gh = require('utils').gh
local registerKeymaps = require('utils').registerKeymaps

local homeVault = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/home'
local oneDriveVault = '~/OneDrive/notes'
local workVault = '~/Developer/notes'
local vault = vim.fn.getcwd() -- Default to current working directory

-- Function to check folder existence
local function folder_exists(path)
  local expanded_path = vim.fn.expand(path)
  local ok, _, code = os.rename(expanded_path, expanded_path)
  return ok or code == 13 -- Code 13 means permission denied but exists
end

-- Determine and set the vault based on folder existence
vault = folder_exists(homeVault) and homeVault or vault
vault = folder_exists(oneDriveVault) and oneDriveVault or vault
vault = folder_exists(workVault) and workVault or vault -- Prioritize based on folder existence

local function search_incomplete_todos()
  require('telescope.builtin').grep_string {
    prompt_title = 'Search Incomplete Todos',
    cwd = vim.fn.expand(vault),
    search = '- [ ]',
    use_regex = false,
    search_dirs = { vim.fn.expand(vault) },
    glob_pattern = '*.md',
  }
end

local obsidian_spec = {
  src = gh 'obsidian-nvim/obsidian.nvim',
  name = 'obsidian.nvim',
  version = 'v3.16.2',
}

vim.pack.add({ obsidian_spec }, { load = false })

local did_setup = false

local function setup_obsidian()
  if did_setup then return end
  did_setup = true

  require('obsidian').setup {
    workspaces = {
      {
        name = 'vault',
        path = vault,
      },
    },

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = 'notes',

    -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*".
    log_level = vim.log.levels.INFO,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'notes/dailies',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily-notes' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },

    -- Disable UI features since render-markdown.nvim is being used
    ui = {
      enable = false,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = 'notes_subdir',

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,

    link = {
      style = 'wiki',
      format = 'shortest',
    },

    frontmatter = {
      -- `false` indicates that you want obsidian.nvim to manage frontmatter.
      enabled = true,
      func = function(note)
        -- Add the title of the note as an alias.
        if note.title then note:add_alias(note.title) end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
    },

    -- Optional, for templates (see below).
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = 'telescope.nvim',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>',
      },
    },

    -- Optional, configure search settings
    search = {
      -- Sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = 'modified',
      sort_reversed = true,
      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      max_lines = 1000,
    },

    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
    -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
    open_notes_in = 'current',

    -- Optional, define your own callbacks to further customize behavior.
    callbacks = {
      -- Runs at the end of `require("obsidian").setup()`.
      ---@param client obsidian.Client
      ---@diagnostic disable-next-line: unused-local
      post_setup = function(client) end,

      -- Runs anytime you enter the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      ---@diagnostic disable-next-line: unused-local
      enter_note = function(client, note) vim.env.NOTES_ASSETS_DIR = vault .. '/assets/imgs' end,

      -- Runs anytime you leave the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      ---@diagnostic disable-next-line: unused-local
      leave_note = function(client, note) end,

      -- Runs right before writing the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      ---@diagnostic disable-next-line: unused-local
      pre_write_note = function(client, note) end,

      -- Runs anytime the workspace is set/changed.
      ---@param client obsidian.Client
      ---@param workspace obsidian.Workspace
      ---@diagnostic disable-next-line: unused-local
      post_set_workspace = function(client, workspace) end,
    },

    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      folder = 'assets/imgs', -- This is the default

      -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
      ---@return string
      img_name_func = function()
        -- Prefix image names with timestamp.
        return string.format('%s-', os.time())
      end,

      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format('![%s](%s)', path.name, path)
      end,
    },
    legacy_commands = false,
  }
end

local function load_obsidian()
  pcall(vim.api.nvim_del_user_command, 'Obsidian')
  vim.cmd.packadd 'obsidian.nvim'
  setup_obsidian()
end

vim.api.nvim_create_user_command('Obsidian', function(cmd_opts)
  load_obsidian()

  local bang = cmd_opts.bang and '!' or ''
  local args = cmd_opts.args ~= '' and (' ' .. cmd_opts.args) or ''
  vim.cmd('Obsidian' .. bang .. args)
end, { nargs = '*', bang = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  once = true,
  callback = load_obsidian,
})

registerKeymaps {
  { ',ov', '<cmd>Obsidian open<CR>', desc = 'Open Obsidian Vault' },
  { ',on', '<cmd>Obsidian new<CR>', desc = 'Create New Obsidian Note' },
  { ',od', '<cmd>Obsidian today<CR>', desc = 'Open Obsidian Daily Note' },
  { ',oq', '<cmd>Obsidian quick switch<CR>', desc = 'Open Obsidian Quick Switcher' },
  { ',of', '<cmd>Obsidian follow link<CR>', desc = 'Follow Obsidian Link' },
  { ',ol', '<cmd>Obsidian link<CR>', desc = 'Insert Wiki Link' },
  { ',ot', '<cmd>Obsidian template<CR>', desc = 'Insert Obsidian Template' },
  { ',os', '<cmd>Obsidian search<CR>', desc = 'Search Obsidian Vault' },
  {
    ',oc',
    function()
      load_obsidian()
      require('obsidian.api').toggle_checkbox { ' ', 'x' }
    end,
    desc = 'Toggle Checkbox',
  },
  { ',oi', search_incomplete_todos, desc = 'Search Incomplete Todos' },
}
