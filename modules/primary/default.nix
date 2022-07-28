{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.primaryPlugins;
in {
  options.vim.primaryPlugins = {
    enable = mkOption {
      type = types.bool;
      description = "enable primaryPlugins plugin: [
        lightspeed.nvim
        nvim-web-devicons
      ]";
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
        lightspeed.nvim
        nvim-web-devicons
      ];
    }
  );
}
        
