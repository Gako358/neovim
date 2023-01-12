{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.lua;

  defaultServer = "lua";
  servers = {
    lua = {
      package = pkgs.sumneko-lua-language-server;
      lspConfig = ''
        lspconfig.sumneko_lua.setup{
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = { "${cfg.lsp.package}/bin/sumneko-lua-language-server" },
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("lua", true),
            },
            telemetry = {
              enable = false,
            };
          };
        }
      '';
    };
  };
in {
  options.vim.languages.lua = {
    enable = mkEnableOption "Lua language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Lua treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "lua";
    };

    lsp = {
      enable = mkOption {
        description = "Lua LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Lua LSP server";
        type = types.str;
        default = defaultServer;
      };
      package = mkOption {
        description = "lua lsp package";
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
      vim.lsp.lspconfig.sources.lua-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
