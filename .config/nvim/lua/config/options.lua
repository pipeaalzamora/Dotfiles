-- Opciones y comportamiento general de Neovim
local opt = vim.opt

-- Numeración de líneas
opt.number = true
opt.relativenumber = true

-- Sangría y tabulación
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Apariencia y colores
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8

-- Rendimiento y portapapeles
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.undofile = true

-- Tecla líder
vim.g.mapleader = " "
vim.g.maplocalleader = " "
