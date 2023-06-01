{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements.";

    nvimWebDevicons.enable = mkEnableOption "dev icons. Required for certain plugins [nvim-web-devicons].";

    cursorWordline = {
      enable = mkEnableOption "word and delayed line highlight [nvim-cursorline].";

      lineTimeout = mkOption {
        description = "Time in milliseconds for cursorline to appear.";
        type = types.int;
        default = 500;
      };
    };

    dropbar.enable = mkEnableOption "dropbar [dropbar-nvim].";

    indentBlankline = {
      enable = mkEnableOption "indentation guides [indent-blankline].";

      listChar = mkOption {
        description = "Character for indentation line.";
        type = types.str;
        default = "│";
      };

      fillChar = mkOption {
        description = "Character to fill indents";
        type = with types; nullOr types.str;
        default = "⋅";
      };

      eolChar = mkOption {
        description = "Character at end of line";
        type = with types; nullOr types.str;
        default = "↴";
      };

      showEndOfLine = mkOption {
        description = nvim.nmd.asciiDoc ''
          Displays the end of line character set by <<opt-vim.visuals.indentBlankline.eolChar>> instead of the
          indent guide on line returns.
        '';
        type = types.bool;
        default = cfg.indentBlankline.eolChar != null;
        defaultText = literalExpression "config.vim.visuals.indentBlankline.eolChar != null";
      };

      showCurrContext = mkOption {
        description = "Highlight current context from treesitter";
        type = types.bool;
        default = config.vim.treesitter.enable;
        defaultText = literalExpression "config.vim.treesitter.enable";
      };

      useTreesitter = mkOption {
        description = "Use treesitter to calculate indentation when possible.";
        type = types.bool;
        default = config.vim.treesitter.enable;
        defaultText = literalExpression "config.vim.treesitter.enable";
      };
    };

    noice = {
      enable = mkEnableOption "Noice configuration.";

      presets = {
        bottomSearch = mkOption {
          default = true;
          description = "Use a classic bottom cmdline for search";
          type = types.bool;
        };

        commandPalette = mkOption {
          default = true;
          description = "Position the cmdline and popupmenu together";
          type = types.bool;
        };

        longMessageToSplit = mkOption {
          default = true;
          description = "Long messages will be sent to a split";
          type = types.bool;
        };

        incRename = mkOption {
          default = false;
          description = "Enables an input dialog for inc-rename.nvim";
          type = types.bool;
        };

        lspDocBorder = mkOption {
          default = false;
          description = "Add a border to hover docs and signature help";
          type = types.bool;
        };
      };
    };

    kommentary.enable = mkEnableOption "commenting plugin [kommentary].";
    todoComments.enable = mkEnableOption "todo comments [todo-comments].";

    toggleTerm.enable = mkOption {
      description = "Toggle terminal with <c-t>";
      type = types.bool;
      default = literalExpression "config.vim.git.lazygit.enable";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.nvimWebDevicons.enable {
      vim.startPlugins = ["nvim-web-devicons"];
    })
    (mkIf cfg.cursorWordline.enable {
      vim.startPlugins = ["nvim-cursorline"];
      vim.luaConfigRC.cursorline = nvim.dag.entryAnywhere ''
        vim.g.cursorline_timeout = ${toString cfg.cursorWordline.lineTimeout}
      '';
    })
    (mkIf cfg.dropbar.enable {
      vim.startPlugins = ["dropbar-nvim"];
    })
    (mkIf cfg.indentBlankline.enable {
      vim.startPlugins = ["indent-blankline"];
      vim.luaConfigRC.indent-blankline = nvim.dag.entryAnywhere ''
        vim.opt.list = true

        ${optionalString (cfg.indentBlankline.eolChar != null) ''
          vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })
        ''}
        ${optionalString (cfg.indentBlankline.fillChar != null) ''
          vim.opt.listchars:append({ space = "${cfg.indentBlankline.fillChar}" })
        ''}

        require("indent_blankline").setup {
          enabled = true,
          char = "${cfg.indentBlankline.listChar}",
          show_end_of_line = ${boolToString cfg.indentBlankline.showEndOfLine},

          use_treesitter = ${boolToString cfg.indentBlankline.useTreesitter},
          show_current_context = ${boolToString cfg.indentBlankline.showCurrContext},
        }
      '';
    })
    (mkIf cfg.kommentary.enable {
      vim.startPlugins = ["kommentary"];
      vim.luaConfigRC.kommentary = nvim.dag.entryAnywhere ''
        require("kommentary.config").configure_language("default", {
          prefer_single_line_comments = true,
          use_consistent_indentation = true,
          ignore_whitespace = true,
        })
      '';
    })
    (mkIf cfg.noice.enable {
      vim.startPlugins = [
        "noice"
        "nui"
        "notify"
      ];
      vim.luaConfigRC.noice = nvim.dag.entryAnywhere ''
        require("noice").setup({
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
            signature = {
              enabled = false,
            },
          },
          presets = {
            bottom_search = ${boolToString cfg.noice.presets.bottomSearch},
            command_palette = ${boolToString cfg.noice.presets.commandPalette},
            long_message_to_split = ${boolToString cfg.noice.presets.longMessageToSplit},
            inc_rename = ${boolToString cfg.noice.presets.incRename},
            lsp_doc_border = ${boolToString cfg.noice.presets.lspDocBorder},
          },
        })
      '';
    })
    (mkIf cfg.todoComments.enable {
      vim.startPlugins = ["todo-comments"];
      vim.luaConfigRC.todo-comments = nvim.dag.entryAnywhere ''
        require("todo-comments").setup {}
      '';
    })
    (mkIf cfg.toggleTerm.enable {
      vim.startPlugins = ["toggleterm"];
      vim.luaConfigRC.toggleterm = nvim.dag.entryAnywhere ''
        require("toggleterm").setup {
          size = 20,
          open_mapping = [[<c-t>]],
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 1,
          start_in_insert = true,
          insert_mappings = true,
          persist_size = true,
          direction = "float",
          float_opts = {
            border = "double",
          },
          close_on_exit = true,
          shell = vim.o.shell,
        }
      '';
    })
  ]);
}
