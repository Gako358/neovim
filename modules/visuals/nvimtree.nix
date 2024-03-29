{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.nvimtree;
in {
  options.vim.visuals.nvimtree = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nvim-tree-lua";
    };

    updateCwd = mkOption {
      default = true;
      description = "Update cwd changes";
      type = types.bool;
    };

    float = mkOption {
      default = true;
      description = "Enable filetree float option";
      type = types.bool;
    };

    border = mkOption {
      default = "rounded";
      description = "Border style for the floating window";
      type = types.enum ["none" "rounded" "solid" "double"];
    };

    widthRatio = mkOption {
      default = 0.5;
      description = "Float tree width";
      type = types.float;
    };

    heightRatio = mkOption {
      default = 0.8;
      description = "Float tree height";
      type = types.float;
    };

    treeSide = mkOption {
      default = "left";
      description = "Side the tree will appear on left or right";
      type = types.enum ["left" "right"];
    };

    treeWidth = mkOption {
      default = 25;
      description = "Width of the tree in charecters";
      type = types.int;
    };

    hideFiles = mkOption {
      default = [".git" "node_modules" ".cache"];
      description = "Files to hide in the file view by default.";
      type = with types; listOf str;
    };

    hideIgnoredGitFiles = mkOption {
      default = false;
      description = "Hide files ignored by git";
      type = types.bool;
    };

    openOnSetup = mkOption {
      default = true;
      description = "Open when vim is started on a directory";
      type = types.bool;
    };

    closeOnLastWindow = mkOption {
      default = true;
      description = "Close when tree is last window open";
      type = types.bool;
    };

    ignoreFileTypes = mkOption {
      default = [];
      description = "Ignore file types";
      type = with types; listOf str;
    };

    closeOnFileOpen = mkOption {
      default = false;
      description = "Closes the tree when a file is opened.";
      type = types.bool;
    };

    resizeOnFileOpen = mkOption {
      default = false;
      description = "Resizes the tree when opening a file.";
      type = types.bool;
    };

    followBufferFile = mkOption {
      default = true;
      description = "Follow file that is in current buffer on tree";
      type = types.bool;
    };

    indentMarkers = mkOption {
      default = true;
      description = "Show indent markers";
      type = types.bool;
    };

    hideDotFiles = mkOption {
      default = false;
      description = "Hide dotfiles";
      type = types.bool;
    };

    openTreeOnNewTab = mkOption {
      default = false;
      description = "Opens the tree view when opening a new tab";
      type = types.bool;
    };

    disableNetRW = mkOption {
      default = false;
      description = "Disables netrw and replaces it with tree";
      type = types.bool;
    };

    hijackNetRW = mkOption {
      default = true;
      description = "Prevents netrw from automatically opening when opening directories";
      type = types.bool;
    };

    trailingSlash = mkOption {
      default = true;
      description = "Add a trailing slash to all folders";
      type = types.bool;
    };

    groupEmptyFolders = mkOption {
      default = true;
      description = "Compact empty folders trees into a single item";
      type = types.bool;
    };

    lspDiagnostics = mkOption {
      default = true;
      description = "Shows lsp diagnostics in the tree";
      type = types.bool;
    };

    systemOpenCmd = mkOption {
      default = "${pkgs.xdg-utils}/bin/xdg-open";
      description = "The command used to open a file with the associated default program";
      type = types.str;
    };

    useSystemClipboard = mkOption {
      default = true;
      description = "Use the system clipboard";
      type = types.bool;
    };

    hijackDirectories = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable directory hijacking";
      };

      autoOpen = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically open hijacked directories";
      };
    };

    updateFocusedFile = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable updating the focused file";
      };

      updateCwd = mkOption {
        type = types.bool;
        default = true;
        description = "Update the current working directory";
      };

      ignoreList = mkOption {
        type = with types; listOf str;
        default = [];
        description = "List of files to ignore";
      };
    };

    systemOpen = {
      cmd = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The command to open a file with the associated default program";
      };

      args = mkOption {
        type = with types; listOf str;
        default = [];
        description = "Arguments for the system open command";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-tree-lua"];

    vim.nnoremap = {
      "<C-n>" = ":NvimTreeToggle<CR>";
      "<leader>tr" = ":NvimTreeRefresh<CR>";
      "<leader>tg" = ":NvimTreeFindFile<CR>";
      "<leader>tf" = ":NvimTreeFocus<CR>";
    };

    vim.luaConfigRC.nvimtreelua =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require'nvim-tree'.setup({
          disable_netrw = ${boolToString cfg.disableNetRW},
          hijack_netrw = ${boolToString cfg.hijackNetRW},
          open_on_tab = ${boolToString cfg.openTreeOnNewTab},
          system_open = {
            cmd = ${"'" + cfg.systemOpenCmd + "'"},
          },
          diagnostics = {
            enable = ${boolToString cfg.lspDiagnostics},
          },
          update_cwd = ${boolToString cfg.updateCwd},
          view  = {
            float = {
              enable = ${boolToString cfg.float},
              open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                local window_w = screen_w * ${toString cfg.widthRatio}
                local window_h = screen_h * ${toString cfg.heightRatio}
                local window_w_int = math.floor(window_w)
                local window_h_int = math.floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((vim.opt.lines:get() - window_h) / 2)
                                 - vim.opt.cmdheight:get()
                return {
                  border = '${cfg.border}',
                  relative = 'editor',
                  row = center_y,
                  col = center_x,
                  width = window_w_int,
                  height = window_h_int,
                }
              end,
            },
            width = function()
              return math.floor(vim.opt.columns:get() * ${toString cfg.widthRatio})
            end,
          },
          renderer = {
            indent_markers = {
              enable = ${boolToString cfg.indentMarkers},
            },
            add_trailing = ${boolToString cfg.trailingSlash},
            group_empty = ${boolToString cfg.groupEmptyFolders},
          },
          hijack_directories = {
            enable = ${boolToString cfg.hijackDirectories.enable},
            auto_open = ${boolToString cfg.hijackDirectories.autoOpen},
          },
          update_focused_file = {
            enable = ${boolToString cfg.updateFocusedFile.enable},
            update_cwd = ${boolToString cfg.updateFocusedFile.updateCwd},
            ignore_list = {
              ${builtins.concatStringsSep "\n" (builtins.map (s: "\"" + s + "\",") cfg.updateFocusedFile.ignoreList)}
            },
          },
          system_open = {
            cmd = ${
          if cfg.systemOpen.cmd == null
          then "nil"
          else "'" + cfg.systemOpen.cmd + "'"
        },
            args = {
              ${builtins.concatStringsSep "\n" (builtins.map (s: "\"" + s + "\",") cfg.systemOpen.args)}
            },
          },
          actions = {
            use_system_clipboard = ${boolToString cfg.useSystemClipboard},
            change_dir = {
              enable = ${boolToString cfg.followBufferFile},
            },
            open_file = {
              quit_on_open = ${boolToString cfg.closeOnFileOpen},
              resize_window = ${boolToString cfg.resizeOnFileOpen},
            },
          },
          git = {
            enable = true,
            ignore = ${boolToString cfg.hideIgnoredGitFiles},
          },
          filters = {
            dotfiles = ${boolToString cfg.hideDotFiles},
            custom = {
              ${builtins.concatStringsSep "\n" (builtins.map (s: "\"" + s + "\",") cfg.hideFiles)}
            },
          },
        })
      '';
  };
}
