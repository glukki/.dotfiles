return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  keys = {
    { "<leader>a", function() require("harpoon"):list():add() end },
    { "<C-d>", function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end},

    --[[
    { "<C-j>", function() require("harpoon"):list():select(1) end },
    { "<C-k>", function() require("harpoon"):list():select(2) end },
    { "<C-l>", function() require("harpoon"):list():select(3) end },
    { "<C-;>", function() require("harpoon"):list():select(4) end },

    { "<C-S-P>", function() require("harpoon"):list():prev() end },
    { "<C-S-N>", function() require("harpoon"):list():next() end },
    --]]
  },
}
