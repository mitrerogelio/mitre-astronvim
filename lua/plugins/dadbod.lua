---@type LazySpec
return {
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = { "DB", "DBCompletion" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    config = function()
      local g = vim.g
      local db_user = vim.fn.getenv "DB_USER"
      local db_password = vim.fn.getenv "DB_PASSWORD"
      local db_host = vim.fn.getenv "DB_HOST"

      g.dbs = {
        staging = "mysql://" .. db_user .. ":" .. db_password .. "@" .. db_host,
      }
      -- Automatically execute SQL files
      g.db_ui_auto_execute_table_helpers = 1
      -- Show notifications
      g.db_ui_show_database_icon = 1
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "sqlite", "mysql", "plsql" },
    config = function()
      local cmp = require "cmp"

      -- Add dadbod completion source to cmp
      cmp.setup.filetype({ "sql", "sqlite", "mysql", "plsql" }, {
        sources = cmp.config.sources {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      })
    end,
  },

  -- Database UI keybindings under Language Tools
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<leader>lq"] = { desc = "SQL Database" },
          ["<leader>lqt"] = { "<cmd>DBUIToggle<CR>", desc = "Toggle Database UI" },
          ["<leader>lqc"] = { "<cmd>DBUIAddConnection<CR>", desc = "Add Database Connection" },
        },
      },
    },
  },
}
