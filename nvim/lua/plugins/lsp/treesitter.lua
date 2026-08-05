return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    config = function()
      vim.defer_fn(function()
        require('nvim-treesitter').setup {}

        vim.api.nvim_create_autocmd('FileType', {
          callback = function(args)
            pcall(vim.treesitter.start, args.buf)
          end,
        })

        vim.api.nvim_create_autocmd('FileType', {
          callback = function()
            if pcall(require, 'nvim-treesitter') then
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })

        require('nvim-treesitter-textobjects').setup {
          select = {
            lookahead = true,
          },
          move = {
            set_jumps = true,
          },
        }

        -- Textobject select keymaps
        local select = require 'nvim-treesitter-textobjects.select'
        vim.keymap.set({ 'x', 'o' }, 'aa', function()
          select.select_textobject('@parameter.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ia', function()
          select.select_textobject('@parameter.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'af', function()
          select.select_textobject('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'if', function()
          select.select_textobject('@function.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ac', function()
          select.select_textobject('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ic', function()
          select.select_textobject('@class.inner', 'textobjects')
        end)

        -- Textobject move keymaps
        local move = require 'nvim-treesitter-textobjects.move'
        vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
          move.goto_next_start('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
          move.goto_next_start('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
          move.goto_next_end('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
          move.goto_previous_start('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
          move.goto_previous_start('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
          move.goto_previous_end('@class.outer', 'textobjects')
        end)
      end, 0)
    end,
  },
}
