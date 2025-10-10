return {
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
        end
    }
}
