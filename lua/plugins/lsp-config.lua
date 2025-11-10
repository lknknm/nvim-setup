return {
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
    },
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
          signs = true,
          highlight = {
            before = '',
          },
        },
    },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd" },
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        config = function()
            -- Global keymaps
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', '<leader>bd', vim.lsp.buf.definition, {})
            vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set({'n', 'v'}, '<leader>lst', ':LspStop<return>', {})
            vim.keymap.set({'n', 'v'}, '<leader>lss', ':LspStart<return>', {})

            -- LSP-specific configurations
            vim.lsp.config('lua_ls', {})
            vim.lsp.config('clangd', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
                cmd = {
                    'clangd',
                    '--compile-commands-dir=build',
                    '--background-index',
                    '--clang-tidy',
                    '--header-insertion=iwyu',
                    '--header-insertion-decorators',
                },
                on_attach = function(client, bufnr)
                    -- Clangd-specific keymap
                    vim.keymap.set('n', '<leader>sh', '<cmd>ClangdSwitchSourceHeader<cr>', { buffer = bufnr, desc = 'Switch between [S]ource and [H]eader' })
                    vim.keymap.set('n', '<leader>fd', vim.lsp.buf.declaration, { desc = 'go to [f]unction [d]eclaration'})
                end
            })

            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = vim.g.border, source = false },
                -- virtual_lines = { current_line = true },
                underline = { severity = vim.diagnostic.severity.ERROR },
                update_in_insert = false,
                signs = vim.g.have_nerd_font and {
                  text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN]  = '󰀪 ',
                    [vim.diagnostic.severity.INFO]  = '󰋽 ',
                    [vim.diagnostic.severity.HINT]  = '󰌶 ',
                  },
                } or {},
                virtual_text = true,
            }
        end
    }
}
