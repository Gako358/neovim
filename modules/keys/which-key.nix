{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.vim.keys;

in {
  options.vim.keys = {
    enable = mkEnableOption "Key binding plugins";

    whichKey = {
      enable = mkEnableOption "whichkey";
    };
  };

  config = mkIf (cfg.enable && cfg.whichKey.enable) {
      vim.startPlugins = with pkgs.neovimPlugins; [
        which-key
      ];
      vim.startLuaConfigRC = ''
        -- Set variable so other plugins can register mappings
        local wk = require("which-key")
      '';

      vim.luaConfigRC = ''
        --setup whichkey
        require("which-key").setup {}
      '';
  };
}
