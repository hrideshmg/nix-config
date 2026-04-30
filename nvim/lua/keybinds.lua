local M = {}

-- [[ Basic Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'i', 'c' }, 'jk', '<Esc>')
vim.keymap.set({ 't' }, 'jk', '<C-\\><C-n>')
vim.keymap.set({ 'n' }, '<c-p>', ':pu<CR>')
vim.keymap.set({ 'v', 'n' }, 'Y', '"+y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set({ 'v', 'n' }, '<C-V>', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'v', 'n' }, '<leader>\\', ':vsp <CR>', { desc = 'Split Vertically' })
vim.keymap.set({ 'v', 'n' }, '<leader>-', ':sp <CR>', { desc = 'Split Horizontally' })
vim.keymap.set({ 'v', 'n' }, '<leader>u', require('telescope').extensions.undo.undo, { desc = '[U]ndo Tree' })
vim.keymap.set('n', '<leader>o', require('nvim-tree.api').tree.open, { desc = '[O]pen file explorer' })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Terminal Mode Keymaps
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'term://*',
  command = 'startinsert',
})
vim.keymap.set({ 't' }, '<C-h>', function()
  vim.cmd 'wincmd h'
end)
vim.keymap.set({ 't' }, '<C-l>', function()
  vim.cmd 'wincmd l'
end)
vim.keymap.set({ 't' }, '<C-j>', function()
  vim.cmd 'wincmd j'
end)
vim.keymap.set({ 't' }, '<C-k>', function()
  vim.cmd 'wincmd k'
end)

-- Run code in a toggleable terminal with tmux
local function toggle_run()
  vim.cmd 'write'
  local get_cmd = function()
    local filetype = vim.bo.filetype
    local source_file = vim.fn.expand '%:p'
    local output_file = vim.fn.expand '%:r'
    if filetype == 'c' then
      return string.format('gcc %s -o /tmp/%s && /tmp/%s', source_file, output_file, output_file)
    elseif filetype == 'python' then
      return string.format('python %s', source_file)
    elseif filetype == 'cpp' then
      return string.format('g++ %s -o %s && ./%s', source_file, output_file, output_file)
    elseif filetype == 'java' then
      return string.format('javac %s && java %s', source_file, output_file, output_file)
    end
  end

  local pane_count = vim.fn.system 'tmux list-panes | wc -l'
  if tonumber(pane_count) == 1 then
    vim.fn.system 'tmux split-window -v -c "#{pane_current_path}" -l 25%'
    vim.fn.timer_start(100, function()
      vim.fn.system(string.format('tmux send-keys -t 2 "%s" C-m', get_cmd()))
    end)
    vim.fn.system 'tmux select-pane -t 1'
  else
    if vim.fn.system "tmux list-panes -F ''#F'' | grep Z" ~= '' then -- If there is a zoomed window
      vim.fn.system 'tmux resize-pane -t1 -Z'
    end
    vim.fn.system(string.format('tmux send-keys -t 2 "" C-m', get_cmd()))
  end
end
vim.keymap.set('n', '<M-Enter>', toggle_run)

-- [[Diagnostics]]
vim.keymap.set('n', '<leader>dN', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[Telescope]]
local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<Esc>'] = actions.close,
      },
      n = {
        ['q'] = actions.close,
      },
    },
  },
}
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Search [F]iles' })
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files { no_ignore = true }
end, { desc = 'Search Hidden [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })

-- [[LSP Keybinds]]
M.lsp_keymaps = function(bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>cr', vim.lsp.buf.rename, 'Code [r]ename')
  nmap('<leader>ca', vim.lsp.buf.code_action, 'Code [a]ction')
  nmap('<leader>cd', require('telescope.builtin').lsp_definitions, 'Goto [d]efinition')
  nmap('<leader>cR', require('telescope.builtin').lsp_references, 'Goto [R]eferences')
  nmap('<leader>cs', require('telescope.builtin').lsp_document_symbols, 'Code [s]ymbols')

  -- See `:help K` for why this keymap
  nmap('M', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  nmap('<leader>cD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
  nmap('<leader>ci', require('telescope.builtin').lsp_implementations, 'Goto [I]mplementation')
end
vim.keymap.set({ 'v', 'n' }, '<Leader>cf', require('conform').format, { desc = '[f]ormat Code' })

-- [[Git keybinds]]
vim.keymap.set({ 'n' }, '<leader>gg', ':OpenInGHFileLines<cr>', { desc = 'Open File In [G]ithub' })

-- git conflicts
vim.keymap.set('n', '<leader>go', ':GitConflictChooseOurs<cr>', { desc = 'Conflict: Choose [O]ur Changes' })
vim.keymap.set('n', '<leader>gt', ':GitConflictChooseTheirs<cr>', { desc = 'Conflict: Choose [T]heir Changes' })
vim.keymap.set('n', ']x', ':GitConflictNextConflict<cr>', { desc = 'Move to next conflict' })
vim.keymap.set('n', '[x', ':GitConflictPrevConflict<cr>', { desc = 'Move to previous conflict' })

-- git signs
M.gitsigns_keybinds = function(bufnr)
  local gs = package.loaded.gitsigns

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map({ 'n', 'v' }, ']c', function()
    if vim.wo.diff then
      return ']h'
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to next hunk' })

  map({ 'n', 'v' }, '[c', function()
    if vim.wo.diff then
      return '[h'
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to previous hunk' })

  -- Actions
  -- Visual mode
  map('v', '<leader>gs', function()
    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = '[S]tage Git Hunk' })
  map('v', '<leader>gr', function()
    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = '[R]eset Git Hunk' })

  -- Normal mode
  map('n', '<leader>gs', gs.stage_hunk, { desc = '[S]tage Git Hunk' })
  map('n', '<leader>gr', gs.reset_hunk, { desc = '[R]eset Git Hunk' })
  map('n', '<leader>gS', gs.undo_stage_hunk, { desc = 'Undo [S]tage Hunk' })
  map('n', '<leader>gp', gs.preview_hunk, { desc = '[P]review Hunk Diff' })
  map('n', '<leader>gb', function()
    gs.blame_line { full = false }
  end, { desc = 'Git Blame Line' })
  map('n', '<leader>gd', gs.diffthis, { desc = 'Git [D]iff Against Staging Area' })
  map('n', '<leader>gD', function()
    gs.diffthis '~'
  end, { desc = 'Git [D]iff Against Last Commit' })
end

-- [[Harpoon]]
local harpoon = require 'harpoon'
vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = '[A]dd To Harpoon List' })
vim.keymap.set('n', '<C-e>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set('n', 'H', function()
  harpoon:list():select(1)
end)
vim.keymap.set('n', 'J', function()
  harpoon:list():select(2)
end)
vim.keymap.set('n', 'K', function()
  harpoon:list():select(3)
end)
vim.keymap.set('n', 'L', function()
  harpoon:list():select(4)
end)

-- [[Comment.nvim]]
local api = require 'Comment.api'
local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
vim.keymap.set('n', '<C-/>', api.toggle.linewise.current)
vim.keymap.set('n', '<C-_>', api.toggle.linewise.current) -- Terminal sometimes recognizes ctrl+/ as ctrl+_
local visual_comment = function()
  vim.api.nvim_feedkeys(esc, 'nx', false)
  api.toggle.linewise(vim.fn.visualmode())
end
vim.keymap.set('v', '<C-/>', visual_comment)
vim.keymap.set('v', '<C-_>', visual_comment)

-- [[Hop.nvim]]
vim.keymap.set({ 'n', 'v' }, 'z', function()
  require('hop').hint_words {}
end, { remap = true })

-- [[nvim-tree]]
M.nvim_tree_keybinds = function(opts, api)
  vim.keymap.set('n', 'C', function()
    api.tree.collapse_all(true)
  end, opts 'Collapse except open buffer')
end

return M
