return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "html", "css", "javascript", "json", "yaml", "markdown" },
				}),
				null_ls.builtins.formatting.asmfmt,
			},
		})
		vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { noremap = true, silent = true })
	end,
}
