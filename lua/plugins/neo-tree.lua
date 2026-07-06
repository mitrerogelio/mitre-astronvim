---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- AstroNvim defaults this to true, which force-quits Neovim whenever
    -- Neo-tree ends up as the only window left in the tab. We want the
    -- opposite: let Neo-tree stay open fullscreen when no files are open.
    close_if_last_window = false,
  },
}
