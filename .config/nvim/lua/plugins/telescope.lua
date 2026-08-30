return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto (grep)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buscar buffers abiertos" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Buscar ayuda" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Archivos recientes" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
