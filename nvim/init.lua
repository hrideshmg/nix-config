-- Disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end

local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- [[ Configure plugins ]]
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  require 'plugins.lsp.lsp_master',
  require 'plugins.lsp.nvim_cmp',
  require 'plugins.lsp.treesitter',
  require 'plugins.formatter',
  require 'plugins.linting',
  require 'plugins.editor',
  require 'plugins.misc',
}, { lazyOptions })

-- [[Auto CMDs]]
-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
vim.api.nvim_create_augroup('mail_trailing_whitespace', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'mail_trailing_whitespace',
  pattern = { 'mail', '' },
  callback = function()
    vim.opt_local.formatoptions:append 'w'
    vim.opt_local.formatoptions:remove 'l'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitsendemail',
  callback = function()
    vim.opt.textwidth = 72
    vim.opt_local.formatoptions:remove 'l'
  end,
})

-- [[ Setting options ]]
-- See `:help vim.o`
vim.o.hlsearch = false
vim.o.scrolloff = 7
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 250
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

-- [[Keymaps]]
require 'keybinds'
