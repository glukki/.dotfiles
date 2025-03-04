return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    keys = {
      { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
      { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Telescope find git files" },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Telescope grep files"
      }

    },
    config = function (_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
