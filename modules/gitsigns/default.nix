{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.gitsigns;
in {
  options.vim.gitsigns = {
    enable = mkOption {
      type = types.bool;
      description = "enable git plugin: [nvim-gitsigns]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-gitsigns
      ];

      vim.luaConfigRC = ''
        require('gitsigns').setup()
      '';
    }
  );
}
