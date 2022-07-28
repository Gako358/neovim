{ pkgs, lib, config }:
with lib;
with builtins;
let
  cfg = config.vim.filetree;
in {
    options.vim.filetree = {
      enable = mkOption {
        type = types.bool;
          description = "Enable filetree plugin: [nvim-filetree]";
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
          nvim-filetree
          web-devicons
        ];

        vim.nnoremap = {
          "<C-n>" = ":NvimTreeToggle<CR>";
          "<leader>tr" = ":NvimTreeRefresh<CR>";
          "<leader>tf" = ":NvimTreeFindFile<CR>";
        };

        vim.luaConfigRC = ''
          require'nvim-tree'.setup {
            open_on_setup = true,
            update_cwd = true,
            view = {
              width = 32,
              height = 32,
              side = "left",
            },
            renderer = {
              indent_markers = {
                enable = false,
                icons = {
                  corner = "└ ",
                  edge = "│ ",
                  none = "  ",
                },
              },
              icons = {
                webdev_colors = true,
              },
            },
            hijack_directories = {
              enable = true,
              auto_open = true,
            },
            update_focused_file = {
              enable = false,
              update_cwd = false,
              ignore_list = {},
            },
            ignore_ft_on_setup = {},
            system_open = {
              cmd = nil,
              args = {},
            },
            diagnostics = {
              enable = false,
              show_on_dirs = false,
              icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
              },
            },
            filters = {
              dotfiles = false,
              custom = {},
              exclude = {},
            },
            git = {
              enable = true,
              ignore = true,
              timeout = 400,
            },
            actions = {
              use_system_clipboard = true,
              change_dir = {
                enable = true,
                global = false,
              },
              open_file = {
                quit_on_open = false,
                resize_window = false,
                window_picker = {
                  enable = true,
                  chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                  exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                  },
                },
              },
            },
            trash = {
              cmd = "trash",
              require_confirm = true,
            },
          }
        '';
      }
    );
}
