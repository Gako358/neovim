{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.undo;
in {
  options.vim.undo = {
    enable = mkEnableOption "enable undotree";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "undotree"
    ];

    vim.luaConfigRC.sql =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require('undotree').setup()
        vim.api.nvim_set_keymap('n', '<leader>u', ':lua require("undotree").toggle()<CR>', {noremap = true, silent = true})
      '';
  };
}
