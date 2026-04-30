return {
  -- Undo tree visualizer
  {
    'debugloop/telescope-undo.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    opts = {
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
      },
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension 'undo'
    end,
  },
  -- Fuzzy Finder (files, lsp, etc)
  {
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          -- NOTE: If you are having trouble with this installation,
          --       refer to the README for telescope-fzf-native for more instructions.
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
      },
      config = function()
        require('telescope').setup {
          pickers = {
            find_files = {
              hidden = true,
            },
          },
        }
        pcall(require('telescope').load_extension, 'fzf')
      end,
    },
  },
  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
    --enabled = false,
    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }
      local hooks = require 'ibl.hooks'
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require('ibl').setup { scope = { highlight = highlight } }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  -- Add colours to hex codes
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    name = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        require('notify').setup {
          background_colour = '#282C34',
        },

        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          local keybinds = require 'keybinds'
          keybinds.nvim_tree_keybinds(opts, api)
        end,
        update_focused_file = {
          enable = true,
        },
        filters = {
          custom = { '^.git$' },
          exclude = { '.venv' },
        },
        view = {
          relativenumber = true,
          float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = function()
              local width = 80
              local height = 30
              local center_x = (vim.api.nvim_win_get_width(0) - width) / 2
              local center_y = (vim.api.nvim_win_get_height(0) - height) / 2
              return {
                relative = 'editor',
                border = 'rounded',
                width = width,
                height = height,
                row = center_y,
                col = center_x,
                bufpos = { 0, 0 },
              }
            end,
          },
        },
      }
      -- Remove ugly colours
      vim.api.nvim_set_hl(0, 'NvimTreeNormal', {
        bg = '',
      })
      vim.api.nvim_set_hl(0, 'NvimTreeNormalFloat', {
        fg = '',
        bg = '#31353F',
      })
      vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', {
        fg = '#31353F',
        bg = '',
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require 'nvim-autopairs'
      npairs.setup {
        check_ts = true,
        ts_config = {
          lua = { 'string' },
          javascript = { 'template_string' },
          java = false,
        },
      }

      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = function()
      require('nvim-ts-autotag').setup {}
    end,
  },
  {
    'smoka7/hop.nvim',
    version = '*',
    config = function()
      require('hop').setup { uppercase_labels = false }
    end,
  },
  {
    'hiphish/rainbow-delimiters.nvim',
    lazy = false,
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = false,
      }
    end,
  },
  {
    'https://gitlab.com/yorickpeterse/nvim-pqf.git',
    config = function()
      require('pqf').setup()
    end,
  },
  {
    'wellle/targets.vim',
  },
  {
    'numToStr/Comment.nvim',
    name = 'comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    {
      'echasnovski/mini.nvim',
      version = '*',
      config = function()
        require('mini.surround').setup()
      end,
    },
  },
}
