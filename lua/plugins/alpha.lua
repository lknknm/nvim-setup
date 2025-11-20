return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "RchrdAriza/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
        local terminal = require("alpha.term")
		local dashboard = require("alpha.themes.dashboard")
		local time = os.date("%H:%M")
		local date = os.date(" %a %d %b")
        local header_path = vim.fn.stdpath('config') .. '/header.txt'

		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

        -- Disable sign column in alpha
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "alpha", callback = function()
                    vim.opt_local.statuscolumn = ""
                    MiniIndentscope.config.symbol = ""
            end
        })

		local function centerText(text, width)
			local totalPadding = width - #text
			local leftPadding = math.floor(totalPadding / 2) + 2
			local rightPadding = totalPadding - leftPadding
			return string.rep(" ", leftPadding) .. text .. string.rep(" ", rightPadding)
		end

        ------------------------------------------------------------------------------------------------------------------
        dashboard.section.header.val = vim.fn.readfile(header_path)
        dashboard.section.header.opts.hl = "@comment"

		dashboard.section.buttons.val = {
            dashboard.button("o", "   Open Recent", "<C-o>"),
			dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
            dashboard.button("f", "󰮗   Find file", ":Telescope find_files<CR>"),
			dashboard.button("R", "󱘞   Ripgrep", ":Telescope live_grep<CR>"),
			dashboard.button("q", "󰗼   Quit", ":qa<CR>"),
		}

		dashboard.section.footer.val = {
			centerText(date, 50),
			centerText(time, 50),
		}
        dashboard.section.footer.opts.hl = "@comment"

		-- Send config to alpha
		alpha.setup(dashboard.opts)
        ------------------------------------------------------------------------------------------------------------------

	end,
}
