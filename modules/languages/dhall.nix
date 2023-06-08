{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.dhall;

  defaultServer = "dhall";
  servers = {
    dhall = {
      package = pkgs.dhall-lsp-server;
      lspConfig = ''
        lspconfig.dhall_lsp_server.setup{
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = {'${cfg.lsp.package}/bin/dhall-lsp-server'};
        }
      '';
    };
  };
in {
  options.vim.languages.dhall = {
    enable = mkEnableOption "Dhall language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Dhall treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "dhall";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Dhall LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Dhall LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Dhall LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.dhall-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
