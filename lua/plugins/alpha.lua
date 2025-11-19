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
                -- Define a function that sets all your custom highlights
        local function set_alpha_highlights()
          -- These commands will run every time you switch colorschemes

          -- Use vim.cmd for simple highlight definitions
          vim.cmd [[highlight AlphaHeader guifg=#FF0000 gui=bold]]
          vim.cmd [[highlight AlphaShortcut guifg=#00FF00]]
          vim.cmd [[highlight AlphaButtons guifg=#0000FF]]
          vim.cmd [[highlight AlphaFooter guifg=#FFFF00]]

          -- Or use the Lua API nvim_set_hl (use this if you prefer Lua table syntax)
          -- vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#FF0000", bold = true })
        end

        -- Create an autocommand group to manage the highlights
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = vim.api.nvim_create_augroup("AlphaCustomization", { clear = true }),
          pattern = "*", -- Match any colorscheme change
          callback = set_alpha_highlights, -- Call the function above
        })

        -- Also call it once when Neovim starts, in case the colorscheme is already set
        set_alpha_highlights()

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
