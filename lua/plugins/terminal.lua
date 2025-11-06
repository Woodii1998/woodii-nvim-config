return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<C-`>]], -- 全局 Toggle（可保留）
      direction = "float",
      start_in_insert = true,
      shade_terminals = true,
      persist_mode = false,
      float_opts = { border = "rounded", winblend = 5 },
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local terms = {}         -- 已创建的终端（按创建顺序）
    local current_idx = 0    -- “当前/最近使用”的索引（1..#terms）

    local function infer_dir()
      local dir = vim.fn.expand("%:p:h")
      if dir == "" or dir:match("^term://") or vim.fn.isdirectory(dir) == 0 then
        dir = vim.fn.getcwd()
      end
      return dir
    end

    -- 工具：聚焦一个终端并记录“最近使用”
    local function focus_term(t)
      t:toggle()             -- 如果关着就开；开着就浮到前台
      -- 把该终端放到队尾，模拟“最近使用”语义
      for i, v in ipairs(terms) do
        if v == t then table.remove(terms, i) break end
      end
      table.insert(terms, t)
      current_idx = #terms
    end

    -- 1) 新建浮动终端（目录默认取当前文件夹，更贴近 VSCode）
    local function new_float_term()
      local t = Terminal:new({ hidden = true, direction = "float", dir = infer_dir() })
      table.insert(terms, t)
      current_idx = #terms
      t:toggle()
    end

    -- 2) Toggle 最近使用的终端（若还未创建就第一次新建）
    local function toggle_current()
      if #terms == 0 then
        new_float_term()
        return
      end
      local t = terms[current_idx]
      if t == nil then
        current_idx = #terms
        t = terms[current_idx]
      end
      t:toggle()
    end

    -- 3) 在终端间循环切换（下一/上一）
    local function next_term()
      if #terms == 0 then return end
      current_idx = (current_idx % #terms) + 1
      focus_term(terms[current_idx])
    end
    local function prev_term()
      if #terms == 0 then return end
      current_idx = ((current_idx - 2) % #terms) + 1
      focus_term(terms[current_idx])
    end

    -- 4) 选择器（vim.ui.select；你装了 Telescope 也会走它的 UI）
    local function list_terms_picker()
      if #terms == 0 then
        vim.notify("暂无终端。按 <leader>tn 新建一个。", vim.log.levels.INFO)
        return
      end
      local items = {}
      for i, t in ipairs(terms) do
        local id = t.id or t.count or i
        local title = t.cmd or "shell"
        local dir = t.dir or vim.loop.cwd()
        table.insert(items, { idx = i, text = string.format("#%d  %s  (%s)", id, title, dir) })
      end
      vim.ui.select(items, {
        prompt = "选择要切换的终端：",
        format_item = function(it) return it.text end,
      }, function(choice)
        if not choice then return end
        current_idx = choice.idx
        focus_term(terms[current_idx])
      end)
    end

    -- 终端内更顺手的窗口切换
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal: Normal mode" })
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })

    -- VSCode 风格键位（普通模式 + 终端模式都可用）
    vim.keymap.set({ "n", "t" }, "<leader>tn", new_float_term, { desc = "Terminal: 新建(浮动)" })
    vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_current, { desc = "Terminal: 当前/最近" })
    vim.keymap.set({ "n", "t" }, "<leader>tp", next_term,    { desc = "Terminal: 下一个" })
    vim.keymap.set({ "n", "t" }, "<leader>tP", prev_term,    { desc = "Terminal: 上一个" })
    vim.keymap.set({ "n", "t" }, "<leader>tl", list_terms_picker, { desc = "Terminal: 列表/切换" })

    -- Bonus：常用工具（可选）
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    vim.keymap.set({ "n", "t" }, "<leader>gg", function() focus_term(lazygit) end, { desc = "Lazygit (float)" })
  end,
}
