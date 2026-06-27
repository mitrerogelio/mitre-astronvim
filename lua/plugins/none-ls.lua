---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- PHPStan: runs on save, results appear as inline diagnostics
      null_ls.builtins.diagnostics.phpstan.with {
        args = { "analyse", "--level=max", "--no-progress", "--error-format=raw", "$FILENAME" },
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      },
      -- Pint: Laravel code formatter
      null_ls.builtins.formatting.pint,
    })
  end,
}
