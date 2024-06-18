{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    trouble = {
      enable = mkEnableOption "trouble diagnostics viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = ["trouble"];

    vim.nnoremap = {
      "<leader>xx" = "<cmd>Trouble diagnostics toggle<CR>";
      "<leader>xX" = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      "<leader>cs" = "<cmd>Trouble symbols toggle focus=false<CR>";
      "<leader>cl" = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
      "<leader>xL" = "<cmd>Trouble loclist toggle<CR>";
      "<leader>xQ" = "<cmd>Trouble qflist toggle<CR>";
    };

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
