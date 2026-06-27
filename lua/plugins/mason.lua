---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "tree-sitter-cli",
        -- PHP
        "intelephense",
        "phpstan",
        "pint",
        -- rector is not in Mason registry; install via composer: composer global require rector/rector
      },
    },
  },
}
