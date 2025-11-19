return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "RchrdAriza/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
        local terminal = require("alpha.term")
		local dashboard = require("alpha.themes.dashboard")
		local time = os.date("%H:%M")
		local date = os.date("%a %d %b")


        -- Define the terminal section
        local term_header = {
          type = "terminal",
          -- Command to run
          -- Adjust the image path to your specific location
          command = "ascii-image-converter C://Users//LucasMellone//Desktop//Pest-ZoomCrows.jpg -C -c -n -f",
          -- command = "neofetch --ascii_bold off", -- Alternative for neofetch
          width = 80,  -- Adjust width as necessary
          height = 25, -- Adjust height as necessary
          opts = {
            position = "center",
            redraw = true, -- Ensures it runs every time the dashboard loads
            window_config = {},
          },
        }

        ------------------------------------------------------------------------------------------------------------------
        dashboard.section.header.val = vim.fn.readfile(vim.fs.normalize("./header.txt"))
		dashboard.section.buttons.val = {
            dashboard.button("o", "   Open Recent", "<C-o>"),
			dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
            dashboard.button("f", "󰮗   Find file", ":Telescope find_files<CR>"),
			dashboard.button("R", "󱘞   Ripgrep", ":Telescope live_grep<CR>"),
			dashboard.button("q", "󰗼   Quit", ":qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)
        ------------------------------------------------------------------------------------------------------------------

		-- Disable folding on alpha buffer
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
			local leftPadding = math.floor(totalPadding / 2)
			local rightPadding = totalPadding - leftPadding
			return string.rep(" ", leftPadding) .. text .. string.rep(" ", rightPadding)
		end

		dashboard.section.footer.val = {
			centerText(date, 50),
			centerText(time, 50),
		}
	end,
}
