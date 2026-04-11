{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp.nvim-lint = {
    enable = mkEnableOption "nvim-lint for linting";

    sources = mkOption {
      description = "nvim-lint Lua configuration sources";
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf cfg.nvim-lint.enable (mkMerge [
    {
      vim.lsp.enable = true;
      vim.startPlugins = [ "nvim-lint" ];

      vim.luaConfigRC.nvim-lint-setup =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            local lint = require("lint")
          '';

      vim.luaConfigRC.nvim-lint =
        nvim.dag.entryAfter [ "nvim-lint-setup" ]
          /*
        lua
          */
          ''
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
              callback = function()
                lint.try_lint()
              end,
            })
          '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryBetween [ "nvim-lint" ] [ "nvim-lint-setup" ] v)) cfg.nvim-lint.sources;
    }
  ]);
}
