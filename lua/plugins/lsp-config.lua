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
			-- In v0.11, we avoid require("lspconfig").[server].setup
			-- and use the native vim.lsp.config/enable system.
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
			--- Lua Setup (Native v0.11 style)
			vim.lsp.config("lua_ls", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})
			------------------------------------------------------------------------
			--- Clangd Setup (Native v0.11 style)
			-- NOTE: "autostart" is an old lspconfig.setup() key; it does nothing
			-- inside vim.lsp.config(). Autostart is now controlled exclusively
			-- via vim.lsp.enable(name, bool) below.
			vim.lsp.config("clangd", {
				cmd = {
					"/usr/bin/clangd",
					"--query-driver=/usr/bin/g++,/usr/bin/clang++",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--header-insertion-decorators",
					"--pch-storage=memory",
					"--malloc-trim",
					"-j=4",
					"--limit-results=50",
				},
				-- Use native root detection
				root_markers = { ".uproject", "compile_commands.json", ".git" },
				capabilities = vim.tbl_deep_extend(
					"force",
					require("blink.cmp").get_lsp_capabilities(),
					{ offsetEncoding = { "utf-16" } }
				),
			})
			------------------------------------------------------------------------
			-- Enable the configs
			vim.lsp.enable("lua_ls")
			-- clangd: registered but NOT autostarted. Toggle it on manually with
			-- <leader>lc, since on this codebase a missing/partial
			-- compile_commands.json makes clangd's autostart attach everywhere
			-- and spam false diagnostics, and full background indexing is too
			-- heavy to run unconditionally on every buffer.
			vim.lsp.enable("clangd", false)
			------------------------------------------------------------------------
			--- Manual clangd toggle
			local clangd_on = false

			local function toggle_clangd()
				clangd_on = not clangd_on
				vim.lsp.enable("clangd", clangd_on)

				if clangd_on then
					-- enable() only wires up autostart for *future* FileType events,
					-- so explicitly start it for the buffer you're already in
					vim.lsp.start(vim.lsp.config.clangd, { bufnr = 0 })
					print("clangd enabled")
				else
					for _, client in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
						client.stop()
					end
					print("clangd disabled")
				end
			end

			vim.keymap.set("n", "<leader>lc", toggle_clangd, { desc = "Toggle clangd" })
			------------------------------------------------------------------------
			--- Attach keymaps for clangd specifically
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "clangd" then
						vim.keymap.set("n", "<leader>sh", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = args.buf })
						vim.keymap.set("n", "<leader>fd", vim.lsp.buf.declaration, { buffer = args.buf })
					end
				end,
			})
			------------------------------------------------------------------------
			--- Diagnostic Config
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
