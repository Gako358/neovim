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
      package = pkgs.lua-language-server;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.lua_ls.setup{
            capabilities = capabilities;
            on_attach = default_on_attach,
            cmd = { "${cfg.lsp.package}/bin/lua-language-server" },
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

  defaultFormat = "lua-format";
  formats = {
    lua-format = {
      package = pkgs.luaformatter;
      nullConfig =
        /*
        lua
        */
        ''
          table.insert(
            ls_sources,
            null_ls.builtins.formatting.lua_format.with({
              command = "${cfg.format.package}/bin/lua-format";
            })
          )
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

    format = {
      enable = mkOption {
        description = "Enable Lua formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Lua formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Lua formatter package";
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
      vim.lsp.lspconfig.sources.lua-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.lua-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
