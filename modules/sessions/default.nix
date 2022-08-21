{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.session;
in {
  options.vim.session = {
    enable = mkOption {
      type = types.bool;
      description = "enable auto-session plugin: [auto-session]";
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
        auto-session
      ];
      
      vim.luaConfigRC = ''
        require'auto-session'.setup {
          log_level = 'error',
          } 
      '';
    }
  );
}
        
