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
      lspConfig = ''
        lspconfig.hls.setup{
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = {'${cfg.lsp.package}/bin/haskell-language-server-wrapper', '--lsp'};
          root_dir = lspconfig.util.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml");
        }
      '';
    };
  };

  defaultFormat = "cabal-fmt";
  formats = {
    cabal-fmt = {
      package = pkgs.haskellPackages.cabal-fmt;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.cabal_fmt.with({
            command = "${cfg.format.package}/bin/cabal-fmt";
          })
        )
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

    format = {
      enable = mkOption {
        description = "Enable Haskell formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Haskell formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Haskell formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
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

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.haskell-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
