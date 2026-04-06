return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
	ft = { "markdown" },
	build = function()
		vim.fn.jobstart({ "npm", "install" }, { cwd = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app" })
	end,
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview toggle" },
	},
	init = function()
		vim.g.mkdp_theme = "dark"
		vim.g.mkdp_auto_close = 1 -- auto close when leaving buffer
		vim.g.mkdp_refresh_slow = 0 -- live refresh as you type
		vim.g.mkdp_open_to_the_world = 0
		vim.g.mkdp_browser = "" -- use system default browser
		vim.g.mkdp_preview_options = {
			mkit = {},
			katex = {},
			uml = {},
			mermaid = {},
			sequence_diagrams = {},
			flowchart_diagrams = {},
			content_editable = false,
			disable_sync_scroll = 0,
			sync_scroll_type = "middle",
		}
	end,
}
