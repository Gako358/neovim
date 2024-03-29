{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.sql;

  defaultServer = "sqlls";
  servers = {
    sqlls = {
      package = pkgs.sqls;
      lspConfig =
        /*
        lua
        */
        ''
          local root_dir = require('lspconfig/util').root_pattern('.git', 'flake.nix')(vim.fn.getcwd())
          lspconfig.sqlls.setup {
            capabilities = capabilities;
            on_attach = attach_keymaps,
            cmd = { "${cfg.lsp.package}/bin/sqls", "-config", string.format("%s/config.yml", root_dir) };
            root_dir = function(fname)
              return root_dir
            end;
          }
        '';
    };
  };
in {
  options.vim.languages.sql = {
    enable = mkEnableOption "SQL language support";

    dialect = mkOption {
      description = "SQL dialect for sqlfluff (if used)";
      type = types.str;
      default = "ansi";
    };

    treesitter = {
      enable = mkOption {
        description = "Enable SQL treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "sql";
    };

    lsp = {
      enable = mkOption {
        description = "Enable SQL LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "SQL LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "SQL LSP server package";
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
      vim.startPlugins = ["sqls-nvim"];

      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.sql-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
