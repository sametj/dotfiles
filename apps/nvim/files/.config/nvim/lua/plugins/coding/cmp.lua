-- ~/.config/nvim/lua/plugins/lsp/completion.lua
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"onsails/lspkind.nvim", -- adds vscode-like icons
		"rafamadriz/friendly-snippets",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		require("luasnip.loaders.from_vscode").lazy_load()
		local kind_highlights = {
			CmpItemKindFunction    = { fg = "#bc8cff" },
			CmpItemKindMethod      = { fg = "#bc8cff" },
			CmpItemKindConstructor = { fg = "#bc8cff" },
			CmpItemKindVariable    = { fg = "#58a6ff" },
			CmpItemKindField       = { fg = "#58a6ff" },
			CmpItemKindProperty    = { fg = "#58a6ff" },
			CmpItemKindClass       = { fg = "#e3b341" },
			CmpItemKindInterface   = { fg = "#e3b341" },
			CmpItemKindStruct      = { fg = "#e3b341" },
			CmpItemKindEnum        = { fg = "#e3b341" },
			CmpItemKindEnumMember  = { fg = "#79c0ff" },
			CmpItemKindConstant    = { fg = "#ffa657" },
			CmpItemKindKeyword     = { fg = "#f85149" },
			CmpItemKindOperator    = { fg = "#f85149" },
			CmpItemKindSnippet     = { fg = "#3fb950" },
			CmpItemKindModule      = { fg = "#79c0ff" },
			CmpItemKindReference   = { fg = "#79c0ff" },
			CmpItemKindTypeParameter = { fg = "#e3b341" },
			CmpItemKindText        = { fg = "#8b949e" },
			CmpItemKindFile        = { fg = "#8b949e" },
			CmpItemKindFolder      = { fg = "#8b949e" },
			CmpItemKindEvent       = { fg = "#f85149" },
			CmpItemKindColor       = { fg = "#3fb950" },
			CmpItemKindUnit        = { fg = "#79c0ff" },
			CmpItemKindValue       = { fg = "#79c0ff" },
		}

		local function apply_highlights()
			for group, opts in pairs(kind_highlights) do
				vim.api.nvim_set_hl(0, group, opts)
			end
		end

		apply_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 40 })(entry, vim_item)
					local parts = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (parts[1] or "") .. " "
					local source_icons = {
						nvim_lsp = "󰒕",
						luasnip = "",
						buffer = "󰦨",
						path = "",
					}
					kind.menu = " " .. (source_icons[entry.source.name] or "?") .. "  " .. (parts[2] or "")
					return kind
				end,
			},

			window = {
				completion = cmp.config.window.bordered({
					border = "rounded",
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					col_offset = -3,
					side_padding = 0,
				}),
				documentation = cmp.config.window.bordered({
					border = "rounded",
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
				}),
			},

			view = {
				entries = { name = "custom", selection_order = "near_cursor" },
			},

			experimental = {
				ghost_text = false, -- subtle inline hint
			},
		})
	end,
}
