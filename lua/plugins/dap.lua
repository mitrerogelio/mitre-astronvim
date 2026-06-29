---@type LazySpec
return {
  -- Core DAP client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- ── PHP / XDebug adapter ──────────────────────────────────────────────
      -- Requires php-debug-adapter installed via Mason (see mason.lua)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath "data" .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for XDebug",
          port = 9003,
          -- If your app runs inside Docker/Valet/Sail, map server paths to local paths:
          -- pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
        },
      }

      -- ── DAP UI ───────────────────────────────────────────────────────────
      dapui.setup {
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.4 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.2 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 12,
          },
        },
      }

      -- Auto-open/close UI with debug sessions
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- ── Virtual text (inline variable values) ────────────────────────────
      require("nvim-dap-virtual-text").setup { commented = true }

      -- ── Breakpoint signs ─────────────────────────────────────────────────
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })
    end,
  },

  -- DAP UI (declared here so lazy.nvim knows to install it)
  { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
  { "theHamsta/nvim-dap-virtual-text" },

  -- ── Keymaps via AstroCore ─────────────────────────────────────────────────
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- Start / stop
          ["<leader>dc"] = { function() require("dap").continue() end, desc = "DAP Continue / Start" },
          ["<leader>dq"] = { function() require("dap").terminate() end, desc = "DAP Terminate" },

          -- Step controls
          ["<leader>dn"] = { function() require("dap").step_over() end, desc = "DAP Step Over" },
          ["<leader>di"] = { function() require("dap").step_into() end, desc = "DAP Step Into" },
          ["<leader>do"] = { function() require("dap").step_out() end, desc = "DAP Step Out" },

          -- Breakpoints
          ["<leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
          ["<leader>dB"] = {
            function()
              require("dap").set_breakpoint(vim.fn.input "Condition: ")
            end,
            desc = "DAP Conditional Breakpoint",
          },

          -- UI
          ["<leader>du"] = { function() require("dapui").toggle() end, desc = "DAP Toggle UI" },
          ["<leader>de"] = {
            function() require("dapui").eval(nil, { enter = true }) end,
            desc = "DAP Eval Expression",
          },
          ["<leader>dl"] = { function() require("dap").run_last() end, desc = "DAP Run Last" },
        },
      },
    },
  },

  -- Add php-debug-adapter to Mason auto-install
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "php-debug-adapter" })
    end,
  },
}
