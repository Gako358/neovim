{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
in {
  config = mkIf (cfg.scheme == "github") {
    vim.startPlugins = with pkgs.neovimPlugins; [github-nvim-theme];

    vim.luaConfigRC = ''
      -- Example config in Lua
      require("github-theme").setup({
        theme_style = "dark",
        function_style = "italic",
        sidebars = {"qf", "vista_kind", "terminal", "packer"},

        -- Change the "hint" color to the "orange" color, and make the "error" color bright red
        colors = {hint = "orange", error = "#ff0000"},

        -- Overwrite the highlight groups
        overrides = function(c)
        return {
          htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
          DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
          -- this will remove the highlight groups
          TSField = {},
        }
      end
      })
    '';
  };
}
