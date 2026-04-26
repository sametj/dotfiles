local formatter = function()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return ""
	end
	local formatters = conform.list_formatters(0)
	if #formatters == 0 then
		return ""
	end
	return "󰛖 "
end

local linter = function()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return ""
	end
	local linters = lint.linters_by_ft[vim.bo.filetype] or {}
	if vim.tbl_isempty(linters) then
		return ""
	end
	return "󱉶 "
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",

	opts = function()
		local function lsp_name()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then return "No LSP" end
			return " " .. clients[1].name
		end

		return {
			options = {
				theme = "auto",
				globalstatus = true,
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "dashboard", "snacks_dashboard", "neo-tree", "lazy" },
			},

			sections = {
				lualine_a = { { "mode", icon = "" } },
				lualine_b = { { "branch", icon = "" } },

				lualine_c = {
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = { left = 1, right = 0 },
					},
					{
						"filename",
						path = 1,
						symbols = { modified = "", readonly = "" },
					},
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},

				lualine_x = {
					formatter,
					linter,
					{ lsp_name },
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					{
						"encoding",
						fmt = string.upper,
					},
				},

				lualine_y = { "progress" },
				lualine_z = {
					{ "location", separator = "" },
					{
						function() return "" end,
						padding = { left = 0, right = 1 },
					},
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			extensions = { "lazy", "mason", "quickfix", "neo-tree" },
		}
	end,

	config = function(_, opts)
		require("lualine").setup(opts)
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

		local function make_lualine_bold()
			local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
			local sections = { "a", "b", "c", "x", "y", "z" }
			for _, mode in ipairs(modes) do
				for _, section in ipairs(sections) do
					local name = ("lualine_%s_%s"):format(section, mode)
					local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
					if next(hl) then
						hl.bold = true
						vim.api.nvim_set_hl(0, name, hl)
					end
				end
			end
		end

		vim.schedule(make_lualine_bold)
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function() vim.schedule(make_lualine_bold) end,
		})
	end,
}
