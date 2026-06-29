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
      g.dbs = {
        -- Example connections - uncomment and modify as needed
        -- SQLite
        -- sqlite_dev = "sqlite:./dev.db",
        -- MySQL/MariaDB
        -- mysql_dev = "mysql://user:password@localhost/database",
        -- MSSQL/SQL Server (T-SQL)
        -- mssql_dev = "sqlserver://user:password@localhost/database",
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
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        }),
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
