{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.shell;

  defaultServer = "bashls";
  servers = {
    bashls = {
      package = pkgs.bash-language-server;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.bashls.setup{
            capabilities = capabilities;
            on_attach = default_on_attach,
            cmd = { "${cfg.lsp.package}/bin/bash-language-server" },
          }
        '';
    };
  };

  defaultFormat = "shfmt";
  formats = {
    shfmt = {
      package = pkgs.shfmt;
      nullConfig =
        /*
        lua
        */
        ''
          table.insert(
            ls_sources,
            null_ls.builtins.formatting.shfmt.with({
              command = "${cfg.format.package}/bin/shfmt";
            })
          )
        '';
    };
  };
in {
  options.vim.languages.shell = {
    enable = mkEnableOption "Shell language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Shell treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "bash";
    };

    lsp = {
      enable = mkOption {
        description = "Shell LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Shell LSP server";
        type = types.str;
        default = defaultServer;
      };
      package = mkOption {
        description = "Shell lsp package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Shell formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Shell formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Shell formatter package";
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
      vim.lsp.lspconfig.sources.bash-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.bash-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
