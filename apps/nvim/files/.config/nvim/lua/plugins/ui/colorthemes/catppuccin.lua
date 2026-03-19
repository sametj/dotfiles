return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	opts = {
		flavour = "macchiato", -- matches your tmux theme
		transparent_background = false,
		term_colors = true,
		integrations = {
			cmp = true,
			gitsigns = true,
			treesitter = true,
			noice = true,
			notify = true,
			mini = { enabled = true },
			lsp_trouble = false,
			mason = true,
			which_key = true,
			snacks = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors      = { "italic" },
					hints       = { "italic" },
					warnings    = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors      = { "underline" },
					hints       = { "underline" },
					warnings    = { "underline" },
					information = { "underline" },
				},
				inlay_hints = { background = true },
			},
		},
	},
}
