return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false), config = true },

      { 'williamboman/mason-lspconfig.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- adds type hints for nixCats global
            { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
          },
        },
      },
    },

    config = function()
      local function which_python()
        local f = io.popen('env which python', 'r') or error "Fail to execute 'env which python'"
        local s = f:read '*a' or error 'Fail to read from io.popen result'
        f:close()
        return string.gsub(s, '%s+$', '')
      end

      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      })

      vim.lsp.config('pylsp', {
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pylint = { enabled = false },
              mccabe = { enabled = false },
              pycodestyle = { enabled = false },
              jedi = { environment = which_python() },
            },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config('clangd', {
        cmd = { 'clangd', '--background-index', '--clang-tidy' },
      })

      vim.lsp.config('docker_compose_language_service', {
        filetypes = { 'yaml.docker-compose' },
      })

      local keybinds = require 'keybinds'
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end
          keybinds.lsp_keymaps(args.buf)
        end,
      })

      local servers = {
        'pylsp',
        'lua_ls',
        'jdtls',
        'ruff',
        'dockerls',
        'docker_compose_language_service',
        'gopls',
        'clangd',
      }
      if require('nixCatsUtils').isNixCats then
        table.insert(servers, 'nixd')
      end

      if require('nixCatsUtils').isNixCats then
        vim.lsp.enable(servers)
      else
        -- Mason path: enable after mason-lspconfig installs them
        require('mason').setup()
        require('mason-lspconfig').setup {
          ensure_installed = servers,
          -- mason-lspconfig ≥ 2.0 auto-calls vim.lsp.enable,
          -- so no setup_handlers needed
        }
        vim.lsp.enable(servers)
      end

      -- Create custom filetype for docker compose
      vim.filetype.add {
        filename = {
          ['docker-compose.yml'] = 'yaml.docker-compose',
          ['docker-compose.yaml'] = 'yaml.docker-compose',
          ['compose.yaml'] = 'yaml.docker-compose',
          ['compose.yml'] = 'yaml.docker-compose',
        },
      }
    end,
  },
}
