{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
in
{
  config = mkIf (cfg.scheme == "kanagawa") {
    vim.startPlugins = with pkgs.neovimPlugins; [ kanagawa ];

    vim.luaConfigRC = ''
      local default_colors = require("kanagawa.colors").setup()
      local my_colors = {
          -- use the palette color name...
          bg = "#272727",
      }
      require'kanagawa'.setup({ colors = my_colors })
      vim.cmd("colorscheme kanagawa")
    '';
  };
}
