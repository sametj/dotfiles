return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "brain",
				path = "~/brain",
			},
		},

		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = "daily.md",
		},

		templates = {
			folder = "templates",
		},

		completion = {
			nvim_cmp = true,
		},

		picker = {
			name = "telescope.nvim",
		},

		ui = {
			enable = false,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
			},
			note_id_func = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					suffix = tostring(os.time())
				end
				return os.date("%Y-%m-%d") .. "-" .. suffix
			end,

			note_frontmatter_func = function(note)
				local out = { id = note.id, title = note.title, date = os.date("%Y-%m-%d"), tags = note.tags }
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,
		},

		follow_url_func = function(url)
			vim.fn.jobstart({ "open", url })
		end,

		attachments = {
			img_folder = "assets",
		},
	},

	keys = {
		{ "<leader>nd", "<cmd>ObsidianToday<cr>", desc = "Daily note" },
		{ "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "New note" },
		{ "<leader>ni", "<cmd>ObsidianNew inbox/<cr>", desc = "Inbox capture" },
		{ "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
		{ "<leader>ng", "<cmd>ObsidianSearch<cr>", desc = "Grep notes" },
		{ "<leader>nl", "<cmd>ObsidianLinks<cr>", desc = "Note links" },
		{ "<leader>nb", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
		{ "<leader>nt", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
		{ "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
	},
}
