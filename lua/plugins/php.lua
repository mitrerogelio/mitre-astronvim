---@type LazySpec
return {
  -- Blade template syntax highlighting
  {
    "jwalton512/vim-blade",
    ft = { "blade", "php" },
  },

  -- Laravel Artisan command runner
  {
    "adalessa/laravel.nvim",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Artisan" },
    keys = {
      { "<leader>la", "<cmd>Artisan<cr>", desc = "Laravel Artisan" },
    },
    opts = {},
  },

  -- PHPStan toggle keymap (<leader>uP)
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<leader>uP"] = {
            function()
              local null_ls = require "null-ls"
              null_ls.toggle { name = "phpstan" }
              vim.notify("PHPStan diagnostics toggled", vim.log.levels.INFO)
            end,
            desc = "Toggle PHPStan diagnostics",
          },
        },
      },
    },
  },
}
