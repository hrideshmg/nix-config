return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    -- Flutter only works with the below commit
    -- commit = '33eb472b459f1d2bf49e16154726743ab3ca1c6d',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          -- add languages to be installed here that you want installed for treesitter
          ensure_installed = require('nixCatsUtils').lazyAdd({ 'c', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' }, {}),
          auto_install = require('nixCatsUtils').lazyAdd(true, false),

          highlight = { enable = false },
          rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
          },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<c-v>',
              node_incremental = '<c-v>',
              scope_incremental = '<c-s>',
              node_decremental = '<c-V>',
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- you can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']f'] = '@function.outer',
                [']]'] = '@class.outer',
              },
              goto_next_end = {
                [']f'] = '@function.outer',
                [']['] = '@class.outer',
              },
              goto_previous_start = {
                ['[f'] = '@function.outer',
                ['[['] = '@class.outer',
              },
              goto_previous_end = {
                ['[f'] = '@function.outer',
                ['[]'] = '@class.outer',
              },
            },
          },
        }
      end, 0)
    end,
  },
}
