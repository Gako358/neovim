{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.github-theme;
in {

  options.vim.theme.github-theme = {
    enable = mkEnableOption "Enable github-nvim theme";

  };

  config = mkIf (cfg.enable) 
  (
    let
      # mkVimBool = val: if val then "1" else "0";
   
    in {

      vim.startPlugins = with pkgs.neovimPlugins; [github-theme];

      vim.luaConfigRC = ''

	require("github-theme").setup({
  	  theme_style = "dark_default",
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
    
    });

}
