return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	opts = {
		-- headings with nice icons
		heading = {
			enabled = true,
			sign = false,
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		-- render checkboxes
		checkbox = {
			enabled = true,
			unchecked = { icon = "󰄱 " },
			checked = { icon = " " },
		},
		-- render code blocks with language label
		code = {
			enabled = true,
			sign = false,
			style = "full",
			border = "thin",
		},
		-- render tables cleanly
		pipe_table = {
			enabled = true,
			style = "full",
		},
		-- bullet points
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
		},
	},
}
