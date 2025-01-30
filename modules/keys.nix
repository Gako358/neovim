{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys;
in
{
  options.vim.keys = {
    enable = mkEnableOption "key binding plugins";

    whichKey = {
      enable = mkEnableOption "which-key menu";
    };
  };

  config = mkIf (cfg.enable && cfg.whichKey.enable) {
    vim.startPlugins = [ "which-key" ];

    vim.luaConfigRC.whichkey = nvim.dag.entryAnywhere ''
      local wk = require("which-key")
      wk.setup {}

      wk.add({
        -- Window navigation
        { "<C-h>", "<C-w>h", desc = "Window Left" },
        { "<C-j>", "<C-w>j", desc = "Window Down" },
        { "<C-k>", "<C-w>k", desc = "Window Up" },
        { "<C-l>", "<C-w>l", desc = "Window Right" },

        -- Window resize
        { "<A-Up>", ":resize -3<CR>", desc = "Decrease Window Height" },
        { "<A-Down>", ":resize +3<CR>", desc = "Increase Window Height" },
        { "<A-Left>", ":vertical resize -3<CR>", desc = "Decrease Window Width" },
        { "<A-Right>", ":vertical resize +3<CR>", desc = "Increase Window Width" },

        -- Tab management
        { "<A-t>", ":tabnew<CR>", desc = "New Tab" },
        { "<A-n>", ":tabnext<CR>", desc = "Next Tab" },
        { "<A-p>", ":tabprevious<CR>", desc = "Previous Tab" },

        -- Misc
        { "<F4>", ":setlocal spell<CR>", desc = "Toggle Spell Check" },
        { "<S-Tab>", ":e #<CR>", desc = "Switch to Last Buffer" },
        { "<C-d>", "<C-d>zz", desc = "Scroll Down (Centered)" },
        { "<C-u>", "<C-u>zz", desc = "Scroll Up (Centered)" },

        -- Quickfix navigation
        { "<A-j>", ":cnext<CR>", desc = "Next Quickfix Item" },
        { "<A-k>", ":cprev<CR>", desc = "Previous Quickfix Item" },

        -- Leader commands
        { "<leader>s", group = "Search" },
        { "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", desc = "Search and Replace" },

        { "<leader>d", group = "Diagnostics" },
        { "<leader>dv", ":noh<CR>", desc = "Clear Search Highlight" },

        { "<leader>b", group = "Buffer" },
        { "<leader>bq", ":BufOnly<CR>", desc = "Close Other Buffers" },

        { "<leader>q", ":cclose<CR>", desc = "Close Quickfix" },
      })

      -- Visual mode mappings
      wk.add({
        { "J", ":m '>+1<CR>gv=gv", desc = "Move Line Down", mode = "v" },
        { "K", ":m '<-2<CR>gv=gv", desc = "Move Line Up", mode = "v" },
      })
    '';
  };
}
