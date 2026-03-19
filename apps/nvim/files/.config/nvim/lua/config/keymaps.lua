vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "jk", "<Esc>", opts)
map("i", "jj", "<Esc>", opts)
map("n", ";", ":", { desc = "Enter command mode" })
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Narrow width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Widen width" })

map("n", "<S-h>",      "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>",        { desc = "Delete current buffer" })

map("n", "<leader>e", "<cmd>Yazi<cr>",        { desc = "Open Yazi (current file)" })
map("n", "<leader>E", "<cmd>Yazi cwd<cr>",    { desc = "Open Yazi (cwd)" })
map("n", "<A-e>",     "<cmd>Yazi toggle<cr>", { desc = "Resume last Yazi session" })

map("v", "<A-j>", ":m '>+1<cr>gv=gv",       { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",       { desc = "Move selection up" })
map("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>-",  "<C-w>s",        { desc = "Horizontal split" })
map("n", "<leader>|",  "<C-w>v",        { desc = "Vertical split" })

map("n", "[d",         vim.diagnostic.goto_prev,  { desc = "Previous diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })

map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

local function get_root()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root ~= "" then return git_root end
	return vim.fn.getcwd()
end

local function open_terminal_in_root()
	require("snacks.terminal")(nil, { size = { width = 0.85, height = 0.85 }, cwd = get_root() })
end

local function open_terminal_in_cwd()
	require("snacks.terminal")(nil, { size = { width = 0.85, height = 0.85 }, cwd = vim.fn.getcwd() })
end

map("n", "<leader>ft", open_terminal_in_root, { desc = "Terminal (Project Root)" })
map("n", "<leader>fT", open_terminal_in_cwd,  { desc = "Terminal (CWD)" })
map("n", "<C-/>",  open_terminal_in_root, { desc = "Toggle Terminal (Root)" })
map("t", "<C-/>",  "<cmd>close<cr>",      { desc = "Hide Terminal" })
map("n", "<C-_>",  open_terminal_in_root, { desc = "Toggle Terminal (Root)" })
map("t", "<C-_>",  "<cmd>close<cr>",      { desc = "Hide Terminal" })
map("n", "<C-\\>", open_terminal_in_root, { desc = "Toggle Terminal (Root)" })
map("t", "<C-\\>", "<cmd>close<cr>",      { desc = "Hide Terminal" })
