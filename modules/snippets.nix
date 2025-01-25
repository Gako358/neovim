{ config, lib, ... }:

with lib;

let
  cfg = config.vim.snippets.vsnip;
in
{
  options.vim.snippets.vsnip = {
    enable = mkEnableOption "Enable vim-vsnip";
    dataDir = mkOption {
      default = builtins.toPath ../../snippets;
      description = "Directory for the snippet files";
      type = types.str;
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      vim-vsnip
    ];

    vim.configRC = ''
      let g:vsnip_snippet_dir = "${cfg.dataDir}"
    '';
  };
}
