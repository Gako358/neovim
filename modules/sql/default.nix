{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.sql;
in {
  options.vim.sql = {
    enable = mkEnableOption "enable dadbod";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "vim-dadbod"
      "vim-dadbod-ui"
      "vim-dadbod-completion"
    ];

    vim.luaConfigRC.sql =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        vim.g.db_ui_use_nerd_fonts = 1
      '';
  };
}
