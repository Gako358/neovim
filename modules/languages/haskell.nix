{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.haskell;

  defaultServer = "haskell";
  servers = {
    haskell = {
      package = pkgs.haskell-language-server;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.hls.setup{
            capabilities = capabilities;
            on_attach = default_on_attach,
            cmd = {'${cfg.lsp.package}/bin/haskell-language-server-wrapper', '--lsp'};
            root_dir = lspconfig.util.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml");
          }
        '';
    };
  };
in {
  options.vim.languages.haskell = {
    enable = mkEnableOption "Haskell language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Haskell treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "haskell";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Haskell LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Haskell LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Haskell LSP server package";
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
      vim.lsp.lspconfig.sources.haskell-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
