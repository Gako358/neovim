{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.bufferline;
in
{
  options.vim.visuals.bufferline = {
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
    in
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-bufferline
      ];

      vim.nnoremap = {
        "<S-w>" = ":BufferLineCycleNext<CR>";
        "<S-TAB>" = ":BufferLineCyclePrev<CR>";
        "<leader>bd" = ":BufferLineSortByDirectory<CR>";
        "<leader>bq" = ":bd!<CR>";

        "<silent><leader>bc" = ":BufferLinePick<CR>";
        "<silent><leader>bse" = ":BufferLineSortByExtension<CR>";
        "<silent><leader>bsd" = ":BufferLineSortByDirectory<CR>";
        "<silent><leader>bsi" = ":lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>";
        "<silent><leader>bmn" = ":BufferLineMoveNext<CR>";
        "<silent><leader>bmp" = ":BufferLineMovePrev<CR>";
        "<silent><leader>b1" = "<Cmd>BufferLineGoToBuffer 1<CR>";
        "<silent><leader>b2" = "<Cmd>BufferLineGoToBuffer 2<CR>";
        "<silent><leader>b3" = "<Cmd>BufferLineGoToBuffer 3<CR>";
        "<silent><leader>b4" = "<Cmd>BufferLineGoToBuffer 4<CR>";
        "<silent><leader>b5" = "<Cmd>BufferLineGoToBuffer 5<CR>";
        "<silent><leader>b6" = "<Cmd>BufferLineGoToBuffer 6<CR>";
        "<silent><leader>b7" = "<Cmd>BufferLineGoToBuffer 7<CR>";
        "<silent><leader>b8" = "<Cmd>BufferLineGoToBuffer 8<CR>";
        "<silent><leader>b9" = "<Cmd>BufferLineGoToBuffer 9<CR>";
      };

      vim.luaConfigRC = ''
        require("bufferline").setup{
           options = {
              numbers = "both",
              buffer_close_icon = '',
              modified_icon = '●',
              close_icon = '',
              left_trunc_marker = '',
              right_trunc_marker = '',
              separator_style = "thin",
              max_name_length = 18,
              max_prefix_length = 15,
              tab_size = 18,
              show_buffer_icons = true,
              show_buffer_close_icons = true,
              show_close_icon = true,
              show_tab_indicators = true,
              persist_buffer_sort = true,
              enforce_regular_tabs = false,
              always_show_bufferline = true,
              offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
              sort_by = 'extension',
              diagnostics = "nvim_lsp",
              diagnostics_update_in_insert = true,
              diagnostics_indicator = function(count, level, diagnostics_dict, context)
                 local s = ""
                 for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and ""
                       or (e == "warning" and "" or "" )
                    if(sym ~= "") then
                    s = s .. " " .. n .. sym
                    end
                 end
                 return s
              end,
              numbers = function(opts)
                return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
              end,
           }
        }
      '';
    }
  );
}
