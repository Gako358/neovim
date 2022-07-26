{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.github;
in {

  options.vim.theme.github = {
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
    mkIfNotNone = val: if val == "none" then null else val;
  in {
    vim.configRC = ''
      colorscheme github_dark
    '';

    vim.startPlugins = with pkgs.neovimPlugins; [github-nvim-theme];
    
  });

}
