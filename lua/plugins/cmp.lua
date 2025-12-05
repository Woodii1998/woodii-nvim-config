return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      -- 回车只换行，不负责补全
      ["<CR>"] = cmp.mapping(function(fallback)
        fallback()
      end, { "i", "s" }),

      -- Tab：优先确认补全，其次跳 snippet，否则插入 Tab
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true }) -- 用 Tab 确认补全
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback() -- 真正的 Tab
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    })

    return opts
  end,
}
