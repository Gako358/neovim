{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.nix;

  useFormat = "on_attach = default_on_attach";
  noFormat = "on_attach = attach_keymaps";

  defaultServer = "nil";
  servers = {
    rnix = {
      package = [ "rnix-lsp" ];
      internalFormatter = cfg.format.type == "nixpkgs-fmt";
      lspConfig = /* lua */ ''
        lspconfig.rnix.setup{
          capabilities = capabilities,
        ${
          if (cfg.format.enable && cfg.format.type == "nixpkgs-fmt")
          then useFormat
          else noFormat
        },
          cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "rnix-lsp"}"},
        }
      '';
    };

    nil = {
      package = [ "nil" ];
      internalFormatter = true;
      lspConfig = /* lua */ ''
        lspconfig.nil_ls.setup{
          capabilities = capabilities,
        ${
          if cfg.format.enable
          then useFormat
          else noFormat
        },
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
          };
        ''}
        }
      '';
    };
  };

  defaultFormat = "alejandra";
  formats = {
    alejandra = {
      package = [ "alejandra" ];
      nullConfig = /* lua */ ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.alejandra.with({
            command = {"${nvim.languages.commandOptToCmd cfg.format.package "alejandra"}"},
          })
        )
      '';
    };
    nixpkgs-fmt = {
      package = [ "nixpkgs-fmt" ];
      # Never need to use null-ls for nixpkgs-fmt
    };
  };

  defaultDiagnostics = [ "statix" "deadnix" ];
  diagnostics = {
    statix = {
      package = pkgs.statix;
      nullConfig = pkg: ''
        table.insert(
          ls_sources,
          null_ls.builtins.diagnostics.statix.with({
            command = "${pkg}/bin/statix",
          })
        )
      '';
    };
    deadnix = {
      package = pkgs.deadnix;
      nullConfig = pkg: ''
        table.insert(
          ls_sources,
          null_ls.builtins.diagnostics.deadnix.with({
            command = "${pkg}/bin/deadnix",
          })
        )
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
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.nix-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf (cfg.format.enable && !servers.${cfg.lsp.server}.internalFormatter) {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.nix-format = formats.${cfg.format.type}.nullConfig;
    })

    (mkIf cfg.extraDiagnostics.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources = lib.nvim.languages.diagnosticsToLua {
        lang = "nix";
        config = cfg.extraDiagnostics.types;
        inherit diagnostics;
      };
    })
  ]);
}
