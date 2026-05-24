return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	opts = {
		opts = {
			enable_close = true,        -- auto-close tags
			enable_rename = true,       -- rename closing tag when opening tag is renamed
			enable_close_on_slash = false,
		},
		per_filetype = {
			["html"] = { enable_close = true },
			["jsx"] = { enable_close = true },
			["tsx"] = { enable_close = true },
			["javascript"] = { enable_close = true },
			["typescript"] = { enable_close = true },
		},
	},
}
