return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "Buscar (Telescope)" },
        { "<leader>w", desc = "Guardar archivo" },
        { "<leader>q", desc = "Cerrar ventana" },
        { "<leader>e", desc = "Explorador de archivos" },
      },
    },
  },
}
