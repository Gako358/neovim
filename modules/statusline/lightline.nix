{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.statusline.lightline;
in {
  options.vim.statusline.lightline = {
    enable = mkEnableOption "Enable lightline";

    theme = mkOption {
      default = "wombat";
      description = "Theme for light line. Can be: powerline, wombat, jellybeans, solarized dark, solarized light, papercolor dark, papercolor light, seoul256, one dark, one light, landscape";
      type = types.enum ["wombat" "powerline" "jellybeans" "solarized dark" "solarized dark" "papercolor dark" "papercolor light" "seoul256" "one dark" "one light" "landscape"];
    };
  };

  config = mkIf (cfg.enable) (
  let 
    lightCfg = {
      "colorscheme" = cfg.theme;
    };
  in {
    vim.startPlugins = with pkgs.neovimPlugins; [ lightline-vim ];

    vim.globals = {
      "lightline" = lightCfg;
    };
  });
}
