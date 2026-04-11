{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.vim.snippets.vsnip;
in
{
  options.vim.snippets.vsnip = {
    enable = mkEnableOption "Enable vim-vsnip";
    dataDir = mkOption {
      default = toString ../../snippets;
      description = "Directory for the snippet files";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    vim = {
      startPlugins = [
        vim-vsnip
      ];

      configRC = ''
        let g:vsnip_snippet_dir = "${cfg.dataDir}"
      '';
    };
  };
}
