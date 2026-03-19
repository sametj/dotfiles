vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true
opt.confirm = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.termguicolors = true
opt.virtualedit = "block"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.showmode = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.winminwidth = 5
opt.pumheight = 10
opt.pumblend = 0

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.shiftround = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"

opt.linebreak = true
opt.wrap = false
opt.conceallevel = 2
opt.smoothscroll = true
vim.g.markdown_recommended_style = 0

opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldtext = ""

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.wildmode = "longest:full,full"

if vim.fn.has("mac") == 1 then
  opt.fillchars = {
    foldopen  = "",
    foldclose = "",
    fold      = " ",
    foldsep   = " ",
    diff      = "╱",
    eob       = " ",
  }
else
  opt.fillchars = {
    foldopen  = "▾",
    foldclose = "▸",
    fold      = " ",
    foldsep   = " ",
    diff      = "╱",
    eob       = " ",
  }
end
