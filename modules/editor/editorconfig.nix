{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.editor.editorconfig;
in {
  options.vim.editor.editorconfig = {
    enable = mkOption {
      type = types.bool;
      description = "enable editorconfig plugin: [nvim-editorconfig]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-editorconfig
      ];
    }
  );
}
