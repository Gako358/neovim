{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.github-nvim;
in {

  options.vim.theme.github-nvim = {
    enable = mkEnableOption "Enable github-nvim theme";

    lineNumberBackgroundColoured = mkOption {
      default = false;
      description = "Set the colour of the line number on the selected line.";
      type = types.bool;
    };

    uniformStatusLine = mkOption {
      default = false;
      description = "Set the status line to be uniform when inactive and active";
      type = types.bool;
    };

    boldVerticalSplit = mkOption {
      default = false;
      description = "Set to have a bold verticle split between panes";
      type = types.bool;
    };

    uniformDiffBackground = mkOption {
      default = false;
      description = "Set to disable colourful backgrounds on diff";
      type = types.bool;
    };


    bold = mkOption {
      default = true;
      description = "Enable bold text";
      type = types.bool;
    };

    italic = mkOption {
      default = false;
      description = "Enable italic text";
      type = types.bool;
    };

    underline = mkOption {
      default = true;
      description = "Enable underlined text";
      type = types.bool;
    };

    italicComments = mkOption {
      default = true;
      description = "Enable italics for comments";
      type = types.bool;
    };

  };

  config = mkIf (cfg.enable) 
  (let
    mkVimBool = val: if val then "1" else "0";
  in {
    vim.configRC = ''
      colorscheme github-nvim
    '';

    vim.startPlugins = with pkgs.neovimPlugins; [github-nvim];
    
  });

}
