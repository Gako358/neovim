{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.vue;

  defaultServer = "volar";
  servers = {
    volar = {
      package = pkgs.nodePackages.volar;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.volar.setup {
            capabilities = capabilities;
            on_attach = default_on_attach,
            cmd = { "${cfg.lsp.package}/bin/vue-language-server", "--stdio" },
            filetypes = {"typescript", "typescriptreact", "javascript", "javascriptreact", "vue", "json"}
          }
        '';
    };
  };
in {
  options.vim.languages.vue = {
    enable = mkEnableOption "Vue language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Vue treesitter support";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "vue";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Vue LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Vue LSP server to use";
        type = types.str;
        default = defaultServer;
      };
      package = mkOption {
        description = "Vue LSP server package";
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
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.vue-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
