{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.css;

  defaultServer = "cssls";
  servers = {
    cssls = {
      package = pkgs.vscode-langservers-extracted;
      lspConfig = /* lua */ ''
        vim.lsp.config('cssls', {
          capabilities = capabilities,
          cmd = {'${cfg.lsp.package}/bin/vscode-css-language-server', '--stdio'},
          filetypes = {'css', 'scss', 'less'},
          settings = {
            css = {
              validate = true,
            },
            less = {
              validate = true,
            },
            scss = {
              validate = true,
            },
          },
        })
        vim.lsp.enable('cssls')
      '';
    };
  };
in
{
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
      vim.lsp.lspconfig = {
        enable = true;
        sources.css-lsp = servers.${cfg.lsp.server}.lspConfig;
      };
    })
  ]);
}
