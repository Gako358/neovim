{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.ts;

  defaultServer = "ts_ls";
  servers = {
    ts_ls = {
      package = pkgs.nodePackages.typescript-language-server;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.ts_ls.setup {
            capabilities = capabilities;
            on_attach = default_on_attach,
            cmd = { "${cfg.lsp.package}/bin/typescript-language-server", "--stdio" },
            filetypes = {"typescript", "javascript"}
          }
        '';
    };
  };

  # TODO: specify packages
  defaultFormat = "prettier";
  formats = {
    prettier = {
      package = pkgs.nodePackages.prettier;
      nullConfig =
        /*
        lua
        */
        ''
          table.insert(
            ls_sources,
            null_ls.builtins.formatting.prettier.with({
              command = "${cfg.format.package}/bin/prettier",
            })
          )
        '';
    };
  };
in
{
  options.vim.languages.ts = {
    enable = mkEnableOption "SQL language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Typescript/Javascript treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      tsPackage = nvim.types.mkGrammarOption pkgs "tsx";
      jsPackage = nvim.types.mkGrammarOption pkgs "javascript";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Typescript/Javascript LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Typescript/Javascript LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Typescript/Javascript LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Typescript/Javascript formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Typescript/Javascript formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Typescript/Javascript formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.tsPackage cfg.treesitter.jsPackage ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.ts-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.ts-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
