---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        "lua",
        "vim",
        "php",
        "phpdoc",
        "blade",
        "html",
        "css",
        "javascript",
        "json",
      },
    },
  },
}
