return {
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = true,
		sign_priority = 8,
		keywords = {
			FIX  = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			TODO = { icon = " ", color = "info" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = "󰅒 ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = "󰍨 ", color = "hint",    alt = { "INFO" } },
			TEST = { icon = "⏲ ", color = "test",    alt = { "TESTING", "PASSED", "FAILED" } },
		},
		highlight = {
			multiline = true,
			before = "",
			keyword = "wide",
			after = "fg",
			pattern = [[.*<(KEYWORDS)\s*:]],
			comments_only = true,
		},
	},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
		{ "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo (all)" },
		{ "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
	},
}
