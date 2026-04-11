{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.python;

  defaultServer = "pyright";
  servers = {
    pyright = {
      package = pkgs.pyright;
      lspConfig =
        /*
        lua
        */
        ''
          vim.lsp.config('pyright', {
            capabilities = capabilities,
            cmd = {"${cfg.lsp.package}/bin/pyright-langserver", "--stdio"},
          })
          vim.lsp.enable('pyright')
        '';
    };
  };

  defaultFormat = "black";
  formats = {
    black = {
      package = pkgs.black;
      conformConfig =
        /*
        lua
        */
        ''
          conform_formatters_by_ft["python"] = { "black" }
          conform_formatters["black"] = {
            command = "${cfg.format.package}/bin/black",
          }
        '';
    };
  };
in
{
  options.vim.languages.python = {
    enable = mkEnableOption "Python language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Python treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "python";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Python LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Python LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Python LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Python formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Python formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Python formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter = {
        enable = true;
        grammars = [ cfg.treesitter.package ];
      };
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig = {
        enable = true;
        sources.python-lsp = servers.${cfg.lsp.server}.lspConfig;
      };
    })

    (mkIf cfg.format.enable {
      vim.lsp.conform = {
        enable = true;
        sources.python-format = formats.${cfg.format.type}.conformConfig;
      };
    })
  ]);
}
