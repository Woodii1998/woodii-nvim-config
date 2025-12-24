return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- 使用 super-tab preset，它已经实现了：Tab 确认补全或跳转 snippet
        preset = "super-tab",
        -- 回车只换行，不负责补全（关闭补全菜单后执行默认换行）
        ["<CR>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.hide() -- 关闭补全菜单
            end
            -- 返回 nil 让 fallback 执行默认换行
          end,
          "fallback",
        },
        -- Control+J：向下选择补全项
        ["<C-j>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next()
            end
          end,
          "fallback",
        },
        -- Control+K：向上选择补全项
        ["<C-k>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_prev()
            end
          end,
          "fallback",
        },
      },
    },
  },
}
