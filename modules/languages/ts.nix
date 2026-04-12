{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.ts;

  defaultServer = "ts_ls";
  servers = {
    ts_ls = {
      package = pkgs.typescript-language-server;
      lspConfig = /* lua */ ''
        vim.lsp.config('ts_ls', {
          capabilities = capabilities,
          cmd = { "${cfg.lsp.package}/bin/typescript-language-server", "--stdio" },
          filetypes = {"typescript", "javascript"},
        })
        vim.lsp.enable('ts_ls')
      '';
    };
  };

  defaultFormat = "prettier";
  formats = {
    prettier = {
      package = [ "prettier" ];
      conformConfig = /* lua */ ''
        conform_formatters_by_ft["javascript"] = { "prettier" }
        conform_formatters_by_ft["typescript"] = { "prettier" }
        conform_formatters_by_ft["javascriptreact"] = { "prettier" }
        conform_formatters_by_ft["typescriptreact"] = { "prettier" }
        conform_formatters["prettier"] = {
          command = "${nvim.languages.commandOptToCmd cfg.format.package "prettier"}",
        }
      '';
    };
  };

  # TODO: specify packages
  defaultDiagnostics = [ "eslint" ];
  diagnostics = {
    eslint = {
      package = pkgs.eslint_d;
      lintConfig = pkg: /* lua */ ''
        lint.linters_by_ft["javascript"] = vim.list_extend(lint.linters_by_ft["javascript"] or {}, { "eslint_d" })
        lint.linters_by_ft["typescript"] = vim.list_extend(lint.linters_by_ft["typescript"] or {}, { "eslint_d" })
        lint.linters_by_ft["javascriptreact"] = vim.list_extend(lint.linters_by_ft["javascriptreact"] or {}, { "eslint_d" })
        lint.linters_by_ft["typescriptreact"] = vim.list_extend(lint.linters_by_ft["typescriptreact"] or {}, { "eslint_d" })
        lint.linters.eslint_d = vim.tbl_deep_extend("force", lint.linters.eslint_d or {}, {
          cmd = "${pkg}/bin/eslint_d",
        })
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
      tsPackage = nvim.options.mkGrammarOption pkgs "tsx";
      jsPackage = nvim.options.mkGrammarOption pkgs "javascript";
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
      package = nvim.options.mkCommandOption pkgs {
        description = "Typescript/Javascript formatter";
        inherit (formats.${cfg.format.type}) package;
      };
    };

    extraDiagnostics = {
      enable = mkOption {
        description = "Enable extra Typescript/Javascript diagnostics";
        type = types.bool;
        default = config.vim.languages.enableExtraDiagnostics;
      };
      types = nvim.options.mkDiagnosticsOption {
        langDesc = "Typescript/Javascript";
        inherit diagnostics;
        inherit defaultDiagnostics;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter = {
        enable = true;
        grammars = [
          cfg.treesitter.tsPackage
          cfg.treesitter.jsPackage
        ];
      };
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig = {
        enable = true;
        sources.ts-lsp = servers.${cfg.lsp.server}.lspConfig;
      };
    })

    (mkIf cfg.format.enable {
      vim.lsp.conform = {
        enable = true;
        sources.ts-format = formats.${cfg.format.type}.conformConfig;
      };
    })

    (mkIf cfg.extraDiagnostics.enable {
      vim.lsp.nvim-lint = {
        enable = true;
        sources = lib.nvim.languages.diagnosticsToLua {
          lang = "ts";
          config = cfg.extraDiagnostics.types;
          inherit diagnostics;
        };
      };
    })
  ]);
}
