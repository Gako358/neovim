{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.xml;

  defaultServer = "lemminx";
  servers = {
    lemminx = {
      package = pkgs.lemminx;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.lemminx.setup{
            capabilities = capabilities;
            on_attach = default_on_attach,
            cmd = { "${cfg.lsp.package}/bin/lemminx" },
          }
        '';
    };
  };

  defaultFormat = "tidy";
  formats = {
    tidy = {
      package = pkgs.html-tidy;
      nullConfig =
        /*
        lua
        */
        ''
          table.insert(
            ls_sources,
            null_ls.builtins.formatting.tidy.with({
              command = "${cfg.format.package}/bin/tidy";
            })
          )
        '';
    };
  };
in {
  options.vim.languages.xml = {
    enable = mkEnableOption "Xml language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Xml treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "xml";
    };

    lsp = {
      enable = mkOption {
        description = "XML LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "XML LSP server";
        type = types.str;
        default = defaultServer;
      };
      package = mkOption {
        description = "XML lsp package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable XML formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "XML formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "XML formatter package";
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
      vim.lsp.lspconfig.sources.xml-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.xml-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
