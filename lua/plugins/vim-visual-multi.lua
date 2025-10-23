return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    -- 不加载插件自带默认快捷键（避免冲突）
    vim.g.VM_default_mappings = 0

    -- 自定义映射，使行为类似 VSCode
    vim.g.VM_maps = {
      ["Find Under"] = "<C-d>", -- 选中下一个相同单词（VSCode同款）
      ["Find Subword Under"] = "<C-d>", -- 对子词也有效
      ["Select All"] = "<C-S-d>", -- 一次性选中所有匹配项
      ["Skip Region"] = "<C-x>", -- 跳过当前匹配
      ["Remove Region"] = "<C-u>", -- 取消上一个匹配（或用 <C-p>）
      ["Add Cursor Down"] = "<C-Down>", -- 向下增加光标（可选）
      ["Add Cursor Up"] = "<C-Up>", -- 向上增加光标（可选）
    }
  end,
}
