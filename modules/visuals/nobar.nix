{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.status;
in
{
  config = mkIf (cfg.bar == "none") {
    vim.configRC = ''
      set laststatus=0
    '';
  };
}
