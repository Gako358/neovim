{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys;
in {
  options.vim.keys = {
    enable = mkEnableOption "key binding plugins";

    whichKey = {
      enable = mkEnableOption "which-key menu";
    };
  };

  config = mkIf (cfg.enable && cfg.whichKey.enable) {
    vim.startPlugins = ["which-key"];

    vim.luaConfigRC.whichkey = nvim.dag.entryAnywhere ''
      local wk = require("which-key")
      wk.setup {}

      -- Normal mode mappings
      wk.register({
        -- Window navigation
        ["<C-h>"] = { "<C-w>h", "Window Left" },
        ["<C-j>"] = { "<C-w>j", "Window Down" },
        ["<C-k>"] = { "<C-w>k", "Window Up" },
        ["<C-l>"] = { "<C-w>l", "Window Right" },

        -- Window resize
        ["<A-Up>"] = { ":resize -3<CR>", "Decrease Window Height" },
        ["<A-Down>"] = { ":resize +3<CR>", "Increase Window Height" },
        ["<A-Left>"] = { ":vertical resize -3<CR>", "Decrease Window Width" },
        ["<A-Right>"] = { ":vertical resize +3<CR>", "Increase Window Width" },

        -- Tab management
        ["<A-t>"] = { ":tabnew<CR>", "New Tab" },
        ["<A-n>"] = { ":tabnext<CR>", "Next Tab" },
        ["<A-p>"] = { ":tabprevious<CR>", "Previous Tab" },

        -- Misc
        ["<F4>"] = { ":setlocal spell<CR>", "Toggle Spell Check" },
        ["<S-Tab>"] = { ":e #<CR>", "Switch to Last Buffer" },
        ["<C-d>"] = { "<C-d>zz", "Scroll Down (Centered)" },
        ["<C-u>"] = { "<C-u>zz", "Scroll Up (Centered)" },

        -- Quickfix navigation
        ["<A-j>"] = { ":cnext<CR>", "Next Quickfix Item" },
        ["<A-k>"] = { ":cprev<CR>", "Previous Quickfix Item" },

        -- Leader commands
        ["<leader>"] = {
          s = {
            name = "Search",
            r = { ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", "Search and Replace" },
          },
          d = {
            name = "Diagnostics",
            v = { ":noh<CR>", "Clear Search Highlight" },
          },
          b = {
            name = "Buffer",
            q = { ":BufOnly<CR>", "Close Other Buffers" },
          },
          q = { ":cclose<CR>", "Close Quickfix" },
        },
      })

      -- Visual mode mappings
      wk.register({
        -- Move lines up and down
        ["J"] = { ":m '>+1<CR>gv=gv", "Move Line Down" },
        ["K"] = { ":m '<-2<CR>gv=gv", "Move Line Up" },
      }, { mode = "v" })
    '';
  };
}
