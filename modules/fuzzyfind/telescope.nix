{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
  cfg = config.vim.fuzzyfind.telescope;
in {
  options.vim.fuzzyfind.telescope = {
    enable = mkEnableOption "Enable telescope";


  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-telescope
      popup-nvim
      plenary-nvim
    ];

    vim.luaConfigRC = ''
      local wk = require("which-key")

      wk.register({
        b = {
          name = "Buffers",
          l = { "List Buffers" },
          c = { "Close buffer" },
        },
        p = {
          name = "Project",
          f = { "Find File"},
          g = { "Grep "},
        },
      }, { prefix = "<leader>" })
    '';

    vim.nnoremap = {
      "<leader>pf" = "<cmd>Telescope find_files<cr>";
      "<leader>pg" = "<cmd>Telescope live_grep<cr>";
      "<leader>bl" = "<cmd>Telescope buffers<cr>";
      "<leader>bc" = "<cmd>bdelete<cr>";
    };


  };
}
