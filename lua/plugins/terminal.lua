return {
  -- ~/.config/nvim/lua/plugins/terminal.lua
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15, -- 终端高度
        open_mapping = [[<C-`>]], -- 改成 Ctrl + `
        shade_terminals = true,
        direction = "horizontal", -- 在底部水平打开，也可以改为 "float" 或 "vertical"
        start_in_insert = true, -- 打开终端后直接进入输入模式
        persist_mode = false, -- 关闭时不记忆上次模式
      })
    end,
  },
}
