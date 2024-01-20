{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.css;

  defaultServer = "cssls";
  servers = {
    cssls = {
      package = pkgs.nodePackages.vscode-css-languageserver-bin;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.cssls.setup{
            on_attach = attach_keymaps,
            cmd = {'${cfg.lsp.package}/bin/vscode-css-languageserver-bin'};
            filetypes = {'css', 'scss', 'less'};
            settings = {
              css = {
                validate = true;
              };
              less = {
                validate = true;
              };
              scss = {
                validate = true;
              };
            };
          }
        '';
    };
  };
in {
  options.vim.languages.css = {
    enable = mkEnableOption "CSS language support";

    lsp = {
      enable = mkOption {
        description = "Enable CSS LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "CSS LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "CSS LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.css-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
