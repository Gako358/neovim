{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.vgit;
in {
  options.vim.vgit = {
    enable = mkOption {
      type = types.bool;
      description = "enable git plugin: [nvim-vgit]";
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
        plenary-nvim         
        nvim-vgit
      ];

      vim.luaConfigRC = ''
        require('vgit').setup()
      '';
    }
  );
}
