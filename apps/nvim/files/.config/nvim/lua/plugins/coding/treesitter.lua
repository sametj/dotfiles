return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		require("nvim-treesitter").setup()
		require("nvim-treesitter.install").install({
			"vim",
			"lua",
			"vimdoc",
			"typescript",
			"javascript",
			"python",
			"html",
			"css",
			"json",
			"bash",
			"yaml",
			"toml",
			"dockerfile",
			"c_sharp",
			"bicep",
			"tsx",
			"regex",
			"markdown",
			"markdown_inline",
			"luau",
		})
	end,
}
