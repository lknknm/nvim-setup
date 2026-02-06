return {
	{
		"nvim-mini/mini.indentscope",
		version = "*",

		init = function()
			-- Use the specific Snacks event for more reliable disabling
			vim.api.nvim_create_autocmd("User", {
				pattern = "SnacksDashboardOpened",
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})

			-- Keep the FileType fallback for other non-text buffers
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,

		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 10,
					animation = function(s, n)
						return 0.5
					end,
				},
				opts = {
					border = "both",
					indent_at_cursor = true,
					n_lines = 10000,
					try_as_border = true,
				},
				symbol = "│",
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
		config = function()
			require("ibl").setup({
				scope = { enabled = false },
				indent = { char = "│" },
			})
		end,
	},
}
