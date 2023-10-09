{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.vue;

  defaultServer = "vuels";
  servers = {
    vuels = {
      package = pkgs.nodePackages.vls;
      lspConfig = ''
        lspconfig.vuels.setup {
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${cfg.lsp.package}/bin/vls", "--stdio" }
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
