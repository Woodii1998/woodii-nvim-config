vim.keymap.set("n", "gh", function()
  vim.diagnostic.open_float(nil, {
    scope = "cursor",
    focus = false,
    border = "rounded",
  })
end, { desc = "Show diagnostics under cursor" })
