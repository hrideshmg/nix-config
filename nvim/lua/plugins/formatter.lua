return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        java = { 'clang-format' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        css = { 'prettier' },
        json = { 'prettier' },
        html = { 'prettier' },
        htmldjango = { 'djlint' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    }
  end,
}
