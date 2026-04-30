return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },

    config = function()
      local ruff_exists = vim.fn.filereadable 'ruff.toml' == 1
      if ruff_exists then
        require('lint').linters_by_ft = { python = { 'ruff' } }
      end
      require('lint').linters_by_ft = {
        html = { 'djlint' },
        htmldjango = { 'djlint' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'TextChanged', 'InsertLeave' }, {
        callback = function()
          local spell = require('lint').linters.codespell
          spell.args = { '-L crate', '--stdin-single-line', '-' }
          require('lint').try_lint()
          require('lint').try_lint 'codespell'
        end,
      })
    end,
  },
}
