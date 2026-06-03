return {
	"lopi-py/luau-lsp.nvim",
	dependencies = { "neovim/nvim-lspconfig" },
	ft = { "lua", "luau" },
	opts = {
		platform = { type = "roblox" },
		types = {
			definition_files = {},
			roblox_security_level = "PluginSecurity",
		},
		sourcemap = {
			enabled = true,
			autogenerate = true,
			rojo_project_file = "default.project.json",
		},
		fflags = {
			sync = true,
		},
	},
}
