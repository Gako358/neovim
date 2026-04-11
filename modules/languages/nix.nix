{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.nix;

  defaultServer = "nil";
  servers = {
    nil = {
      package = [ "nil" ];
      internalFormatter = true;
      lspConfig =
        /*
        lua
        */
        ''
          vim.lsp.config('nil_ls', {
            capabilities = capabilities,
            cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "nil"}"},
          ${optionalString cfg.format.enable ''
            settings = {
              ["nil"] = {
            ${optionalString (cfg.format.type == "alejandra")
              ''
                formatting = {
                  command = {"${cfg.format.package}/bin/alejandra", "--quiet"},
                },
              ''}
            ${optionalString (cfg.format.type == "nixpkgs-fmt")
              ''
                formatting = {
                  command = {"${cfg.format.package}/bin/nixpkgs-fmt"},
                },
              ''}
              },
            },
          ''}
          })
          vim.lsp.enable('nil_ls')
        '';
    };
  };

  defaultFormat = "nixpkgs-fmt";
  formats = {
    alejandra = {
      package = [ "alejandra" ];
      conformConfig =
        /*
        lua
        */
        ''
          conform_formatters_by_ft["nix"] = { "alejandra" }
          conform_formatters["alejandra"] = {
            command = "${nvim.languages.commandOptToCmd cfg.format.package "alejandra"}",
            args = { "--quiet", "-" },
          }
        '';
    };
    nixpkgs-fmt = {
      package = [ "nixpkgs-fmt" ];
      # Never need to use conform for nixpkgs-fmt — it uses LSP internal formatter
    };
  };

  defaultDiagnostics = [ "statix" "deadnix" ];
  diagnostics = {
    statix = {
      package = pkgs.statix;
      lintConfig = pkg: ''
        lint.linters_by_ft["nix"] = vim.list_extend(lint.linters_by_ft["nix"] or {}, { "statix" })
        lint.linters.statix = vim.tbl_deep_extend("force", lint.linters.statix or {}, {
          cmd = "${pkg}/bin/statix",
        })
      '';
    };
    deadnix = {
      package = pkgs.deadnix;
      lintConfig = pkg: ''
        lint.linters_by_ft["nix"] = vim.list_extend(lint.linters_by_ft["nix"] or {}, { "deadnix" })
        lint.linters.deadnix = vim.tbl_deep_extend("force", lint.linters.deadnix or {}, {
          cmd = "${pkg}/bin/deadnix",
        })
      '';
    };
  };
in
{
  options.vim.languages.nix = {
    enable = mkEnableOption "Nix language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Nix treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.options.mkGrammarOption pkgs "nix";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Nix LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Nix LSP server to use";
        type = types.str;
        default = defaultServer;
      };
      package = nvim.options.mkCommandOption pkgs {
        description = "Nix LSP server";
        inherit (servers.${cfg.lsp.server}) package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Nix formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Nix formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = nvim.options.mkCommandOption pkgs {
        description = "Nix formatter package";
        inherit (formats.${cfg.format.type}) package;
      };
    };

    extraDiagnostics = {
      enable = mkOption {
        description = "Enable extra Nix diagnostics";
        type = types.bool;
        default = config.vim.languages.enableExtraDiagnostics;
      };
      types = lib.nvim.options.mkDiagnosticsOption {
        langDesc = "Nix";
        inherit diagnostics;
        inherit defaultDiagnostics;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.configRC.nix = nvim.dag.entryAnywhere ''
        autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
      '';
    }

    (mkIf cfg.treesitter.enable {
      vim.treesitter = {
        enable = true;
        grammars = [ cfg.treesitter.package ];
      };
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig = {
        enable = true;
        sources.nix-lsp = servers.${cfg.lsp.server}.lspConfig;
      };
    })

    (mkIf (cfg.format.enable && !servers.${cfg.lsp.server}.internalFormatter) {
      vim.lsp.conform = {
        enable = true;
        sources.nix-format = formats.${cfg.format.type}.conformConfig;
      };
    })

    (mkIf cfg.extraDiagnostics.enable {
      vim.lsp.nvim-lint = {
        enable = true;
        sources = lib.nvim.languages.diagnosticsToLua {
          lang = "nix";
          config = cfg.extraDiagnostics.types;
          inherit diagnostics;
        };
      };
    })
  ]);
}
