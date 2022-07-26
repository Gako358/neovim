{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.gruvbox;
  gruvboxPallet = [
    "bg" "red" "green" "yellow" "blue" "purple" "aqua" "gray" 
    "orange" "bg0" "bg1" "bg2" "bg3" "bg4"
    "fg0" "fg1" "fg2" "fg3" "fg4" "none"
  ];
in {
  options.vim.theme.gruvbox = {
    enable = mkEnableOption "Enable gruvbox theme";

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

    transparentBackground = mkOption {
      default = false;
      description = "Enable transparent background";
      type = types.bool;
    };

    underline = mkOption {
      default = true;
      description = "Enable underlined text";
      type = types.bool;
    };

    undercurl = mkOption {
      default = true;
      description = "Enable undercurl text";
      type = types.bool;
    };

    termColours = mkOption {
      default = "256";
      description = "Uses 256 term colours by default. If there is a issue set to 16";
      type = types.str;
    };

    contrastDark = mkOption {
      default = "medium";
      description = "The contrast when in dark mode. Can be soft, medium or hard";
      type = types.enum [ "soft" "medium" "hard"];
    };

    contrastLight = mkOption {
      default = "medium";
      description = "The contrast when in light mode. Can be soft, medium or hard";
      type = types.enum [ "soft" "medium" "hard"];
    };

    hlsCursor = mkOption {
      default = "orange";
      description = "Gruvbox pallet to assign to search highlight cursor";
      type = types.enum gruvboxPallet; 
    };

    numberColumn = mkOption {
      default = "none";
      description = "Gruvbox pallet to assign to the number column background";
      type = types.enum gruvboxPallet;
    };

    signColumn = mkOption {
      default = "bg1";
      description = "Gruvbox pallet to assign to the sign column background";
      type = types.enum gruvboxPallet;
    };

    colourColumn = mkOption {
      default = "bg1";
      description = "Gruvbox pallet to assign to the colour column background";
      type = types.enum gruvboxPallet;
    };

    virticalSplit = mkOption {
      default = "bg0";
      description = "Gruvbox pallet to assign to the virtical split background";
      type = types.enum gruvboxPallet;
    };

    italicComments = mkOption {
      default = true;
      description = "Enable italics for comments";
      type = types.bool;
    };

    italicStrings = mkOption {
      default = false;
      description = "Enable italics for strings";
      type = types.bool;
    };

    invertSelected = mkOption {
      default = true;
      description = "Invert colours of selected text";
      type = types.bool;
    };

    invertSigns = mkOption {
      default = false;
      description = "Invert colours of signs. Useful for gitgutter";
      type = types.bool;
    };

    invertIdentGuides = mkOption {
      default = false;
      description = "Inverts indent guides";
      type = types.bool;
    };

    invertTabline = mkOption {
      default = false;
      description = "Invert the tabline highlights, providing distinguishable tabline-fill";
      type = types.bool;
    };

    improvedStrings = mkOption {
      default = false;
      description = "Extrahighlighted strings";
      type = types.bool;
    };

    improvedWarnings = mkOption {
      default = false;
      description = "Extrahighlighted warnings";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) 
  (let
    mkVimBool = val: if val then "1" else "0";
    mkIfNotNone = val: if val == "none" then null else val;
  in {
    vim.configRC = ''
      colorscheme gruvbox
    '';

    vim.startPlugins = with pkgs.neovimPlugins; [gruvbox];
    vim.globals = {
      "gruvbox_bold" = mkVimBool cfg.bold;
      "gruvbox_italic" = mkVimBool cfg.italic;
      "gruvbox_transparent_bg" = mkVimBool cfg.transparentBackground;
      "gruvbox_underline" = mkVimBool cfg.underline;
      "gruvbox_undercurl" = mkVimBool cfg.undercurl;
      "gruvbox_termcolors" = mkIfNotNone cfg.termColours;
      "gruvbox_contrast_dark" = mkIfNotNone cfg.contrastDark;
      "gruvbox_contrast_light" = mkIfNotNone cfg.contrastLight;
      "gruvbox_hls_cursor" = mkIfNotNone cfg.hlsCursor;
      "gruvbox_number_column" = mkIfNotNone cfg.numberColumn;
      "gruvbox_sign_column" = mkIfNotNone cfg.signColumn;
      "gruvbox_virt_split" = mkIfNotNone cfg.virticalSplit;
      "gruvbox_italicize_comments" = mkVimBool cfg.italicComments;
      "gruvbox_italicize_strings" = mkVimBool cfg.italicStrings;
      "gruvbox_invert_selection" = mkVimBool cfg.invertSelected;
      "gruvbox_invert_signs" = mkVimBool cfg.invertSigns;
      "gruvbox_invert_ident_guides" = mkVimBool cfg.invertIdentGuides;
      "gruvbox_invert_tabline" = mkVimBool cfg.invertTabline;
      "gruvbox_improved_strings" = mkVimBool cfg.improvedStrings;
      "gruvbox_improved_warnings" = mkVimBool cfg.improvedWarnings;
    };
  });
}
