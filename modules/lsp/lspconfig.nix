{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp.lspconfig = {
    enable = mkEnableOption "nvim-lspconfig, also enabled automatically";

    sources = mkOption {
      description = "nvim-lspconfig sources";
      type = with types; attrsOf str;
      default = {};
    };
  };

  config = mkIf cfg.lspconfig.enable (mkMerge [
    {
      vim.lsp.enable = true;

      vim.startPlugins = ["nvim-lspconfig"];

      vim.luaConfigRC.lspconfig = nvim.dag.entryAfter ["lsp-setup"] ''
        local lspconfig = require('lspconfig')
        lspconfig.lua_ls.setup {
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
              client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                  runtime = {
                    version = 'LuaJIT'
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME
                    }
                  }
                }
              })
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
          end
        }
      '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter ["lspconfig"] v)) cfg.lspconfig.sources;
    }
  ]);
}
