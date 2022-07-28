{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.vim.bufferline;

in {
  options.vim.bufferline = {
    enable = mkOption {
      type = types.bool;
      description = "Enable bufferline plugin: [nvim-bufferline]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
      if cond 
      then msg
      else "";

    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        "nvim-bufferline"
      ];

      vim.nnoremap = {
        "<leader>d" = ":BufferLineCycleNext<CR>";
        "<leader>a" = ":BufferLineCyclePrev<CR>";
        "<leader>bd" = ":BufferLineSortByDirectory<CR>";
        "<leader>bq" = ":bd!<CR>";
        
        "<leader>1" = "<cmd>BufferLineGoToBuffer 1<CR>";
        "<leader>2" = "<cmd>BufferLineGoToBuffer 2<CR>";
        "<leader>3" = "<cmd>BufferLineGoToBuffer 3<CR>";
        "<leader>4" = "<cmd>BufferLineGoToBuffer 4<CR>";
        "<leader>5" = "cmd>BufferLineGoToBuffer 5<CR>";
        "<leader>6" = "<cmd>BufferLineGoToBuffer 6<CR>";
        "<leader>7" = "<cmd>BufferLineGoToBuffer 7<CR>";
        "<leader>8" = "<cmd>BufferLineGoToBuffer 8<CR>";
        "<leader>9" = "<cmd>BufferLineGoToBuffer 9<CR>";
        
        "<leader>q" = ":qa!<CR>";
      };
      
      vim.luaConfigRC = ''
        require("bufferline").setup({
          options = {
            offsets = { { filetype = "NvimTree", text = " Explorer", padding = 1 } },
            numbers = "buffer_id",
            buffer_close_icon = "",
            modified_icon = "",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 14,
            max_prefix_length = 13,
            tab_size = 20,
            diagnostic = false,
            show_tab_indicators = true,
            enforce_regular_tabs = false,
            view = "multiwindow",
            show_buffer_close_icons = true,
            separator_style = "slant",
            always_show_bufferline = true,
          },
        })
      '';
    }
  );
}
