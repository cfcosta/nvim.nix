vim.cmd.packadd("packer.nvim")

return require('packer').startup(function(use)
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function()
        vim.keymap.set('n', '<space><space>', ':Telescope find_files<cr>', opts)
        vim.keymap.set('n', '<space>/', ':Telescope live_grep<cr>', opts)
        vim.keymap.set('n', '<space>bb', ':Telescope buffers<cr>', opts)
      end
    }

    use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'ryanoasis/vim-devicons'
      },
      config = function()
        vim.keymap.set('n', '<space>op', ':NvimTreeToggle<cr>', opts)
      end
    }

    use {
      'TimUntersberger/neogit',
      requires = {
        'nvim-lua/plenary.nvim',
        'sindrets/diffview.nvim'
      },
      config = function()
        vim.keymap.set('n', '<space>gg', ':Neogit<cr>', opts)
        local neogit = require("neogit")

        neogit.setup({
          use_magit_keybindings = true,
          integrations = {
            diffview = true
          }
        })
      end
    }

    use({
        'dracula/vim',
        as = 'dracula',
        config = function()
          vim.cmd('colorscheme dracula')
        end
    })

    use {
      'VonHeikemen/lsp-zero.nvim',

      requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
      },

      config = function ()
        local lsp = require("lsp-zero")

        lsp.preset("recommended")

        -- Fix Undefined global 'vim'
        lsp.configure('sumneko_lua', {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' }
              }
            }
          }
        })

        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}
        local cmp_mappings = lsp.defaults.cmp_mappings({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        })

        lsp.setup_nvim_cmp({
          mapping = cmp_mappings
        })

        lsp.set_preferences({
          suggest_lsp_servers = false,
          sign_icons = {
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
          }
        })

        lsp.on_attach(function(client, bufnr)
          local opts = {buffer = bufnr, remap = false}

          if client.name == "eslint" then
            vim.cmd.LspStop('eslint')
            return
          end

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<space>vws", vim.lsp.buf.workspace_symbol, opts)
          vim.keymap.set("n", "<space>vd", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<space>rr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        end)

        lsp.setup()

        vim.diagnostic.config({
          virtual_text = true,
        })
      end
    }

    use({
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
    })

    use("direnv/direnv.vim")
    use("github/copilot.vim")
    use('jeffkreeftmeijer/neovim-sensible')
    use({
      'kylechui/nvim-surround',
      config = function()
        require("nvim-surround").setup({})
      end
    })
    use('mbbill/undotree')
    use('nvim-treesitter/playground')
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    use('terrortylor/nvim-comment')
    use('tpope/vim-fugitive')
    use({
      'sbdchd/neoformat',
      config = function()
        vim.cmd([[
        augroup fmt
          autocmd!
          autocmd BufWritePre * undojoin | Neoformat
        augroup END
        ]])
      end
  })
end)
