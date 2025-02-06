{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.html;
in {
  options.vim.languages.html = {
    enable = mkEnableOption "HTML language support";

    treesitter = {
      enable = mkOption {
        description = "Enable HTML treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "html";

      autotagHtml = mkOption {
        description = "Enable autoclose/autorename of html tags (nvim-ts-autotag)";
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })
  ]);
}
