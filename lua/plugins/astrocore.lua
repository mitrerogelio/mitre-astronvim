
-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- Autocommands can be configured through AstroCore as well
    autocmds = {
      neotree_fullscreen_on_empty = {
        {
          event = "BufEnter",
          desc = "Close the leftover empty buffer window so Neo-tree fills the screen when no files are open",
          callback = function(args)
            -- ignore Neo-tree's own buffer to avoid recursing on itself
            if vim.bo[args.buf].filetype == "neo-tree" then return end
            -- only act on a genuinely blank, unnamed, unmodified buffer
            if
              vim.bo[args.buf].buftype ~= ""
              or vim.api.nvim_buf_get_name(args.buf) ~= ""
              or vim.bo[args.buf].modified
            then
              return
            end
            local wins = vim.api.nvim_tabpage_list_wins(0)
            -- only trigger when Neo-tree is the only other window left
            if #wins ~= 2 then return end
            local current_win = vim.api.nvim_get_current_win()
            local has_neotree = false
            for _, win in ipairs(wins) do
              if win ~= current_win and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
                has_neotree = true
              end
            end
            if has_neotree then vim.schedule(function() pcall(vim.cmd.close) end) end
          end,
        },
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        autoread = true, -- auto-reload files when modified on disk
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>by"] = {
          function()
            local filepath = vim.fn.expand "%"
            vim.fn.setreg("+", filepath)
            vim.notify("Copied to clipboard: " .. filepath, vim.log.levels.INFO)
          end,
          desc = "Yank current buffer's filepath to clipboard",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
