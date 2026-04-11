{
  config,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp.conform = {
    enable = mkEnableOption "conform.nvim for formatting";

    sources = mkOption {
      description = "conform.nvim Lua configuration sources";
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf cfg.conform.enable (mkMerge [
    {
      vim = {
        lsp.enable = true;
        startPlugins = [ "conform-nvim" ];

        luaConfigRC.conform-setup = nvim.dag.entryAnywhere /* lua */ ''
          local conform = require("conform")
          local conform_formatters_by_ft = {}
          local conform_formatters = {}
        '';

        luaConfigRC.conform = nvim.dag.entryAfter [ "conform-setup" "lsp-setup" ] /* lua */ ''
          conform.setup({
            formatters_by_ft = conform_formatters_by_ft,
            formatters = conform_formatters,
            ${optionalString cfg.formatOnSave ''
              format_on_save = {
                timeout_ms = 3000,
                lsp_format = "fallback",
              },
            ''}
          })

          vim.keymap.set({'n', 'v'}, '<leader>lf', function()
            conform.format({ async = true, lsp_format = "fallback" })
          end, { noremap = true, silent = true, desc = "Format buffer" })
        '';
      };
    }
    {
      vim.luaConfigRC = mapAttrs (
        _: v: (nvim.dag.entryBetween [ "conform" ] [ "conform-setup" ] v)
      ) cfg.conform.sources;
    }
  ]);
}
