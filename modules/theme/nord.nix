{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.nord;
in {

  options.vim.theme.nord = {
    enable = mkEnableOption "Enable nord theme";

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
      colorscheme nord
    '';

    vim.startPlugins = with pkgs.neovimPlugins; [nord-vim];

    vim.globals = {
      "nord_cursor_line_number_background" = mkVimBool cfg.lineNumberBackgroundColoured;
      "nord_uniform_status_line" = mkVimBool cfg.uniformStatusLine;
      "nord_bold_vertical_split_line" = mkVimBool cfg.boldVerticalSplit;
      "nord_bold" = mkVimBool cfg.bold;
      "nord_italic" = mkVimBool cfg.italic;
      "nord_italic_comments" = mkVimBool cfg.italicComments;
      "nord_underline" = mkVimBool cfg.underline;
    };
  });

}
