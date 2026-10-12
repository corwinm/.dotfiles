local gh = require('utils').gh

vim.pack.add {
  gh 'emrearmagan/atlas.nvim',
}

require('atlas').setup {
  providers = {
    github = {
      -- hostname = "github.company.com", -- Defaults to GH_HOST, then github.com.
      cache_ttl = 300, -- Set to 0 to disable caching.
    },
  },
}
