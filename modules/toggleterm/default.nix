{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.toggleterm;

in {
  options.vim.toggleterm = {
    enable = mkOption {
      type = types.bool;
      description = "Enable toggleterm plugin: [toggleterm]";
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
        toggleterm
      ];

      vim.luaConfigRC = ''
        require("toggleterm").setup()
      '';
    }
  );
}
