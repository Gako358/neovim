{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.theme;
in
{
  config = mkIf (cfg.scheme == "gruvbox") {
    vim.startPlugins = with pkgs.neovimPlugins; [ gruvbox ];

    vim.luaConfigRC = ''
      -- setup must be called before loading the colorscheme
      -- Default options:
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = true,
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("colorscheme gruvbox")
    '';
  };
}
