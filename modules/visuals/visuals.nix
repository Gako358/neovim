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
    autopairs = {
      enable = mkEnableOption "auto pairs [nvim-autopairs]";

      type = mkOption {
        type = types.enum ["nvim-autopairs"];
        default = "nvim-autopairs";
        description = "Set the autopairs type. Options: nvim-autopairs [nvim-autopairs]";
      };
    };
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

    kommentary.enable = mkEnableOption "commenting plugin [kommentary].";

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

    todoComments.enable = mkEnableOption "todo comments [todo-comments].";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.nvimWebDevicons.enable {
      vim.startPlugins = ["nvim-web-devicons"];
    })
    (mkIf cfg.autopairs.enable {
      vim.startPlugins = ["nvim-autopairs"];
      vim.luaConfigRC.autopairs =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          require("nvim-autopairs").setup{}
        '';
    })
    (mkIf cfg.indentBlankline.enable {
      vim.startPlugins = ["indent-blankline"];
      vim.luaConfigRC.indent-blankline =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          vim.opt.list = true
          local highlight = {
              "RainbowRed",
              "RainbowYellow",
              "RainbowBlue",
              "RainbowOrange",
              "RainbowGreen",
              "RainbowViolet",
              "RainbowCyan",
          }

          local hooks = require "ibl.hooks"
          -- create the highlight groups in the highlight setup hook, so they are reset
          -- every time the colorscheme changes
          hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
              vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
              vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
              vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
              vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
              vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
              vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
              vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
          end)

          require("ibl").setup {
            -- indent = { highlight = highlight, char = "|" },
            indent = {
              highlight = highlight,
              char = "▏",
              tab_char = ".",
            },
            whitespace = {
              highlight = highlight,
              remove_blankline_trail = false,
            },
            scope = {
              show_start = false,
              show_end = false,
            },
          }
        '';
    })
    (mkIf cfg.kommentary.enable {
      vim.startPlugins = ["kommentary"];
      vim.luaConfigRC.kommentary =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
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
      vim.luaConfigRC.noice =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
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

          require("notify").setup({
            background_colour = "#000000"
          })
        '';
    })
    (mkIf cfg.todoComments.enable {
      vim.startPlugins = ["todo-comments"];
      vim.luaConfigRC.todo-comments =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          require("todo-comments").setup {}
        '';
    })
  ]);
}
