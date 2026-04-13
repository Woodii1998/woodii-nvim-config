local js_like = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "css",
  "scss",
  "html",
  "yaml",
  "markdown",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.eslint = opts.servers.eslint or {}
      opts.servers.eslint.settings = vim.tbl_deep_extend("force", opts.servers.eslint.settings or {}, {
        workingDirectories = { mode = "auto" },
        format = true,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(js_like) do
        opts.formatters_by_ft[ft] = {
          "prettier",
          stop_after_first = true,
          lsp_format = "fallback",
          filter = function(client)
            return client.name == "eslint"
          end,
        }
      end
    end,
  },
}
