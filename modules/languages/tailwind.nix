{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.tailwind;

  defaultServer = "tailwind";
  servers = {
    tailwind = {
      package = pkgs.nodePackages."@tailwindcss/language-server";
      lspConfig = ''
        lspconfig.tailwindcss.setup{
          on_attach = attach_keymaps,
          cmd = {'${cfg.lsp.package}/bin/tailwind-language-server'};
        }
      '';
    };
  };
in {
  options.vim.languages.tailwind = {
    enable = mkEnableOption "Tailwind CSS language support";

    lsp = {
      enable = mkOption {
        description = "Enable CSS LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "CSS LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Tailwind CSS LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.tailwind-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
