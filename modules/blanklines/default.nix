{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.blanklines;

in {
  options.vim.blanklines = {
    enable =mkOption {
      type = types.bool;
      description = "Enable blank lines plugin: [indent-blanklines]";
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
        indent-blanklines
      ];

      vim.luaConfigRC = ''
        vim.opt.list = true
        vim.opt.listchars:append "eol:↴"
        
        require("indent_blankline").setup {
            show_end_of_line = true,
        }
      '';
    }
  );
}
