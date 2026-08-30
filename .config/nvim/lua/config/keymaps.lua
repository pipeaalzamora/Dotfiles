-- Atajos de teclado (Keymaps) de Neovim
local map = vim.keymap.set

-- Navegación rápida entre ventanas
map("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana inferior" })
map("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana superior" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- Redimensionar ventanas con flechas
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Aumentar altura" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Reducir altura" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Reducir ancho" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Aumentar ancho" })

-- Mover líneas seleccionadas en modo visual
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba" })

-- Guardar y salir rápidamente
map("n", "<leader>w", ":w<CR>", { desc = "Guardar archivo" })
map("n", "<leader>q", ":q<CR>", { desc = "Cerrar ventana" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Salir forzado sin guardar" })

-- Limpiar resaltado de búsqueda
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Limpiar búsqueda" })
