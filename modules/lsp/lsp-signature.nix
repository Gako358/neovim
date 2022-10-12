{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp = {
    lspSignature = {
      enable = mkEnableOption "lsp signature viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.lspSignature.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [ lsp-signature ];

    vim.luaConfigRC = ''
      -- Enable lsp signature viewer
      cfg = {
        max_height = 7,
        max_width = 55,
        floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

        floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
        floating_window_off_x = 1,
        floating_window_off_y = 3,

        handler_opts = {
          border = "rounded"   -- double, rounded, single, shadow, none
        },

        always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

        auto_close_after = nil,
        extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 10, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
      }

      -- recommended:
      require'lsp_signature'.setup(cfg)
    '';
  };
}
