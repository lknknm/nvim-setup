return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = true, highlight = { before = "" } },
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			------------------------------------------------------------------------
            --- Global keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>bd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>lss", ":LspStart<CR>", { desc = "Start LSP" })
			vim.keymap.set("n", "<leader>lst", function()
				for _, client in ipairs(vim.lsp.get_clients()) do
					client.stop()
				end
				print("All LSP clients stopped")
			end, { desc = "Stop all LSP clients" })

			------------------------------------------------------------------------
			------------------------------------------------------------------------
			vim.lsp.config("lua_ls", {
				autostart = false,
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			------------------------------------------------------------------------
			------------------------------------------------------------------------
			vim.lsp.config("clangd", {
				autostart = false,
				-- Root detection is handled via nvim-lspconfig patterns automatically,
				-- but we can reinforce it here:
				root_dir = require("lspconfig.util").root_pattern(".uproject", "compile_commands.json", ".git"),
				capabilities = vim.tbl_deep_extend(
					"force",
					require("blink.cmp").get_lsp_capabilities(),
					{ offsetEncoding = { "utf-16" } }
				),
				cmd = {
					"clangd",
					"--compile-commands-dir=build",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--header-insertion-decorators",
					-- Arch/Linux Memory Optimizations
					"--pch-storage=disk",
					"--malloc-trim",
					"-j=4",
					"--limit-results=50",
				},
			})

			------------------------------------------------------------------------
            ------------------------------------------------------------------------
			-- Attach keymaps for clangd specifically
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.name == "clangd" then
						vim.keymap.set("n", "<leader>sh", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = args.buf })
						vim.keymap.set("n", "<leader>fd", vim.lsp.buf.declaration, { buffer = args.buf })
					end
				end,
			})

			------------------------------------------------------------------------
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("clangd")

			------------------------------------------------------------------------
			-- Diagnostic Config
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = false },
				underline = { severity = vim.diagnostic.severity.ERROR },
				update_in_insert = false,
				virtual_text = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				},
			})
		end,
	},
}
