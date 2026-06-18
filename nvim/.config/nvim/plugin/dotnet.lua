-- dotnet.lua
--
-- C#/.NET support via roslyn.nvim (the open-source Roslyn LSP that powers the
-- VS Code C# Dev Kit). Razor/Blazor/CSHTML is handled by roslyn.nvim's built-in
-- co-hosting -- no separate `rzls.nvim` is needed.
--
-- Requirements (installed automatically):
--  - .NET SDK with `dotnet` on PATH (already present)
--  - `roslyn` Mason package (see registries + ensure_installed in plugin/00-init.lua)
--
-- Lazily loaded on the first C# or Razor buffer, mirroring plugin/go.lua.

local gh = require('utils').gh

vim.pack.add({
  gh 'seblyng/roslyn.nvim',
}, { load = false })

local did_setup = false

local function setup_roslyn()
  if did_setup then return end
  did_setup = true

  require('roslyn').setup {
    -- Search parent directories for a solution file so projects that aren't a
    -- direct child of the .sln directory still attach correctly.
    broad_search = true,
  }

  -- Server-specific settings. The base `roslyn` LSP config is provided by the
  -- plugin, so this must run after `packadd` (i.e. inside this setup function).
  vim.lsp.config('roslyn', {
    settings = {
      ['csharp|inlay_hints'] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      },
      ['csharp|code_lens'] = {
        dotnet_enable_references_code_lens = true,
      },
      ['csharp|completion'] = {
        dotnet_show_completion_items_from_unimported_namespaces = true,
        dotnet_show_name_completion_suggestions = true,
      },
    },
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cs', 'razor' },
  callback = function()
    vim.cmd.packadd 'roslyn.nvim'
    setup_roslyn()
  end,
})
