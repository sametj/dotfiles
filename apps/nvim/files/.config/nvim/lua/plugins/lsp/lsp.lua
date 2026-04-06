return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		local mason_lspconfig = require("mason-lspconfig")
		require("mason").setup()

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- ─────────────────────────────── Servers ───────────────────────────────
		local servers = {
			lua_ls = {
				root_dir = function(fname)
					local util = require("lspconfig.util")
					if type(fname) == "number" then
						fname = vim.api.nvim_buf_get_name(fname)
					end
					if fname == "" then
						fname = vim.uv.cwd()
					end
					return util.find_git_ancestor(fname)
						or util.root_pattern(".luarc.json", ".luarc.jsonc", ".git")(fname)
						or vim.fn.expand("~/.config/nvim")
				end,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = { checkThirdParty = false },
						diagnostics = { globals = { "vim" } },
						completion = { callSnippet = "Replace" },
						hint = {
							enable = true,
							setType = true,
							arrayIndex = "Disable",
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
						},
						codeLens = { enable = true },
						doc = { privateName = { "^_" } },
					},
				},
			},
			emmet_language_server = {
				filetypes = {
					"html",
					"css",
					"javascript",
					"javascriptreact",
					"typescriptreact",
					"vue",
					"svelte",
					"astro",
				},
				init_options = {
					includeLanguages = {
						javascript = "javascriptreact",
						typescript = "typescriptreact",
					},
					showExpandedAbbreviation = "always",
					showAbbreviationSuggestions = true,
					syntaxProfiles = {},
					variables = {},
					preferences = {},
				},
			},

			vtsls = {
				settings = {
					typescript = {
						tsserver = {
							maxTsServerMemory = 8192,
						},
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = false },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			},

			pyright = {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoImportCompletions = true,
						},
					},
				},
			},

			tailwindcss = {
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								"tw`([^`]*)",
								'tw="([^"]*)',
								'tw={"([^"}]*)',
								"clsx%(([^)]*)%)",
								"classnames%(([^)]*)%)",
							},
						},
					},
				},
			},
		}

		-- ───────────────────────────── Diagnostics ─────────────────────────────
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			virtual_text = {
				spacing = 4,
				prefix = "●",
				source = "if_many",
				severity = { min = vim.diagnostic.severity.WARN },
			},
			signs = true,
		})

		-- ─────────────────────────── Mason + LSP Config ─────────────────────────
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})

		for name, opts in pairs(servers) do
			opts.capabilities = capabilities
			vim.lsp.config(name, opts)
			vim.lsp.enable(name)
		end

		-- ───────────────────────────── LSP Keymaps ─────────────────────────────
		-- gd/gD/gr are handled by Snacks picker (snacks.lua)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
			callback = function(args)
				local bufnr = args.buf
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("n", "K", vim.lsp.buf.hover, "Hover Docs")
				map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
			end,
		})

		-- ───────────────────────────── Inlay Hints ─────────────────────────────
		if vim.lsp.inlay_hint then
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
			})
		end

		-- ────────────────────────────── Folding ────────────────────────────────
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
	end,
}
