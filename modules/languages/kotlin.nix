{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.kotlin;

  defaultServer = "kotlin";
  servers = {
    kotlin = {
      package = pkgs.kotlin-language-server;
      lspConfig =
        /*
        lua
        */
        ''
          vim.lsp.config('kotlin_language_server', {
            capabilities = capabilities,
            cmd = {'${cfg.lsp.package}/bin/kotlin-language-server'},
          })
          vim.lsp.enable('kotlin_language_server')
        '';
    };
  };

  defaultFormat = "ktlint";
  formats = {
    ktlint = {
      package = pkgs.ktlint;
      conformConfig =
        /*
        lua
        */
        ''
          conform_formatters_by_ft["kotlin"] = { "ktlint" }
          conform_formatters["ktlint"] = {
            command = "${cfg.format.package}/bin/ktlint",
          }
        '';
    };
  };

  defaultDiagnostics = [ "ktlint" ];
  diagnostics = {
    ktlint = {
      package = pkgs.ktlint;
      lintConfig = pkg: ''
        lint.linters_by_ft["kotlin"] = vim.list_extend(lint.linters_by_ft["kotlin"] or {}, { "ktlint" })
        lint.linters.ktlint = vim.tbl_deep_extend("force", lint.linters.ktlint or {}, {
          cmd = "${pkg}/bin/ktlint",
        })
      '';
    };
  };
in
{
  options.vim.languages.kotlin = {
    enable = mkEnableOption "Kotlin language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Kotlin treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "kotlin";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Kotlin LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "kotlin LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Kotlin LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Kotlin formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Kotlin formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Kotlin formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };

    extraDiagnostics = {
      enable = mkOption {
        description = "Enable extra Kotlin diagnostics";
        type = types.bool;
        default = config.vim.languages.enableExtraDiagnostics;
      };
      types = lib.nvim.types.diagnostics {
        langDesc = "Kotlin";
        inherit diagnostics;
        inherit defaultDiagnostics;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.kotlin-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.lsp.conform.enable = true;
      vim.lsp.conform.sources.kotlin-format = formats.${cfg.format.type}.conformConfig;
    })

    (mkIf cfg.extraDiagnostics.enable {
      vim.lsp.nvim-lint.enable = true;
      vim.lsp.nvim-lint.sources = lib.nvim.languages.diagnosticsToLua {
        lang = "kotlin";
        config = cfg.extraDiagnostics.types;
        inherit diagnostics;
      };
    })
  ]);
}
