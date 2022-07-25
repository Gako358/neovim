{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.autopairs;
in {
  options.vim.autopairs = {
    enable = mkOption {
      type = types.bool;
      description = "enable autopairs plugin: [nvim-autopairs]";
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
        nvim-autopairs
      ];
      
      vim.luaConfigRC = ''
        require'nvim-autopairs'.setup {}
        
      '';
    }
  );
}
        
