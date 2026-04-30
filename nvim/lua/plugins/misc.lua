return {
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require 'notify'
      require('notify').setup {
        render = 'compact',
      }
    end,
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  -- Git related plugins
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local keybinds = require 'keybinds'
        keybinds.gitsigns_keybinds(bufnr)
      end,
    },
  },
  -- Adds command to open file on github
  {
    'almo7aya/openingh.nvim',
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
  },
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      -- document existing key chains
      local wk = require 'which-key'
      wk.setup {
        icons = {
          mappings = false,
        },
        plugins = {
          marks = false,
          presets = {
            g = false,
          },
        },
      }
      wk.add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]iagnostics' },
        { '<leader>g', group = '[G]it' },
        { '<leader>r', desc = 'Search [R]ecent Files' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]orkspace' },
      }
    end,
  },
  -- Set lualine as statusline
  {
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
  -- Tmux integration
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
}
