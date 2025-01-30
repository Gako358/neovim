{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp = {
    trouble = {
      enable = mkEnableOption "trouble diagnostics viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = [ "trouble" ];

    vim.luaConfigRC.trouble-maps = nvim.dag.entryAnywhere ''
      if ${boolToString config.vim.keys.whichKey.enable} then
        local wk = require("which-key")
        wk.add({
          { "<leader>x", group = "Trouble" },
          { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Toggle Diagnostics" },
          { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Toggle Global Diagnostics" },
          { "<leader>xt", "<cmd>Trouble todo<CR>", desc = "Todo List" },
          { "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Location List" },
          { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix List" },

          { "<leader>c", group = "Code" },
          { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Toggle Symbols" },
          { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Toggle LSP" },
        })
      end
    '';

    vim.luaConfigRC.trouble =
      nvim.dag.entryAnywhere
        /*
      lua
        */
        ''
          -- Enable trouble diagnostics viewer
          require("trouble").setup {}
        '';
  };
}
