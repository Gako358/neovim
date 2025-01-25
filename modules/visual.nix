{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in
{
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements.";

    autopairs = {
      enable = mkEnableOption "auto pairs [nvim-autopairs]";

      type = mkOption {
        type = types.enum [ "nvim-autopairs" ];
        default = "nvim-autopairs";
        description = "Set the autopairs type. Options: nvim-autopairs [nvim-autopairs]";
      };
    };

    bufferline = {
      enable = mkEnableOption "Enable bufferline";

      icons = mkOption {
        description = "Enable icons for bufferline";
        type = types.bool;
        default = true;
      };

      numbers = mkOption {
        description = "Show buffer numbers";
        type = types.str;
        default = "both";
      };

      separatorStyle = mkOption {
        description = "Style of the separator between buffers";
        type = types.str;
        default = "thin";
      };

      showBufferClose = mkOption {
        description = "Show buffer close icons";
        type = types.bool;
        default = true;
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

    lualine = {
      enable = mkEnableOption "lualine statusline.";
      icons = mkOption {
        description = "Enable icons for lualine";
        type = types.bool;
        default = true;
      };

      theme = mkOption {
        description = "Theme for lualine";
        type = types.str;
        default = "auto";
        defaultText = ''`config.vim.theme.name` if theme supports lualine else "auto"'';
      };

      sectionSeparator = {
        left = mkOption {
          description = "Section separator for left side";
          type = types.str;
          default = "";
        };

        right = mkOption {
          description = "Section separator for right side";
          type = types.str;
          default = "";
        };
      };

      componentSeparator = {
        left = mkOption {
          description = "Component separator for left side";
          type = types.str;
          default = "⏽";
        };

        right = mkOption {
          description = "Component separator for right side";
          type = types.str;
          default = "⏽";
        };
      };

      activeSection = {
        a = mkOption {
          description = "active config for: | (A) | B | C       X | Y | Z |";
          type = types.str;
          default = "{'mode'}";
        };

        b = mkOption {
          description = "active config for: | A | (B) | C       X | Y | Z |";
          type = types.str;
          default = ''
            {
              {
                "branch",
                  separator = '',
              },
                "diff",
            }
          '';
        };

        c = mkOption {
          description = "active config for: | A | B | (C)       X | Y | Z |";
          type = types.str;
          default = "{'filename'}";
        };

        x = mkOption {
          description = "active config for: | A | B | C       (X) | Y | Z |";
          type = types.str;
          default = ''
            {
              {
                "diagnostics",
                  sources = {'nvim_lsp'},
                  separator = '',
                  symbols = {error = '', warn = '', info = '', hint = ''},
              },
                {
                  "filetype",
                },
                "fileformat",
                "encoding",
            }
          '';
        };

        y = mkOption {
          description = "active config for: | A | B | C       X | (Y) | Z |";
          type = types.str;
          default = "{'progress'}";
        };

        z = mkOption {
          description = "active config for: | A | B | C       X | Y | (Z) |";
          type = types.str;
          default = "{'location'}";
        };
      };

      inactiveSection = {
        a = mkOption {
          description = "inactive config for: | (A) | B | C       X | Y | Z |";
          type = types.str;
          default = "{}";
        };

        b = mkOption {
          description = "inactive config for: | A | (B) | C       X | Y | Z |";
          type = types.str;
          default = "{}";
        };

        c = mkOption {
          description = "inactive config for: | A | B | (C)       X | Y | Z |";
          type = types.str;
          default = "{'filename'}";
        };

        x = mkOption {
          description = "inactive config for: | A | B | C       (X) | Y | Z |";
          type = types.str;
          default = "{'location'}";
        };

        y = mkOption {
          description = "inactive config for: | A | B | C       X | (Y) | Z |";
          type = types.str;
          default = "{}";
        };

        z = mkOption {
          description = "inactive config for: | A | B | C       X | Y | (Z) |";
          type = types.str;
          default = "{}";
        };
      };
    };

    luatab.enable = mkEnableOption "Luatab [luatab]";
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

        incRename = mkOption {
          default = false;
          description = "Enables an input dialog for inc-rename.nvim";
          type = types.bool;
        };

        longMessageToSplit = mkOption {
          default = true;
          description = "Long messages will be sent to a split";
          type = types.bool;
        };

        lspDocBorder = mkOption {
          default = false;
          description = "Add a border to hover docs and signature help";
          type = types.bool;
        };
      };
    };

    nvimWebDevicons.enable = mkEnableOption "dev icons. Required for certain plugins [nvim-web-devicons].";
    ranger.enable = mkEnableOption "Ranger filetree [ranger]";
    theme.enable = mkEnableOption "Theme configuration.";
    todo.enable = mkEnableOption "Todo highlights [nvim-todo]";
    undo.enable = mkEnableOption "Undo tree [undotree]";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.autopairs.enable {
      vim.startPlugins = [ "nvim-autopairs" ];
      vim.luaConfigRC.autopairs =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("nvim-autopairs").setup{}
          '';
    })
    (mkIf cfg.bufferline.enable {
      vim.startPlugins = [
        "bufferline"
        "bufdelete"
      ];

      vim.nnoremap = {
        "<leader>bn" = "<cmd>BufferLineCycleNext<CR>";
        "<leader>bp" = "<cmd>BufferLineCyclePrev<CR>";
        "<leader>bc" = "<cmd>BufferLinePick<CR>";
        "<leader>bse" = "<cmd>BufferLineSortByExtension<CR>";
        "<leader>bsd" = "<cmd>BufferLineSortByDirectory<CR>";
        "<leader>bmn" = "<cmd>BufferLineMoveNext<CR>";
        "<leader>bmp" = "<cmd>BufferLineMovePrev<CR>";
      };

      vim.luaConfigRC.bufferline =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("bufferline").setup{
              options = {
                numbers = "${cfg.bufferline.numbers}",
                close_command = function(bufnum)
                  require("bufdelete").bufdelete(bufnum, false)
                end,
                right_mouse_command = "vertical sbuffer %d",
                indicator = {
                  icon = "▎",
                  style = "icon"
                },
                buffer_close_icon = "",
                modified_icon = "●",
                close_icon = "",
                left_trunc_marker = "",
                right_trunc_marker = "",
                separator_style = "${cfg.bufferline.separatorStyle}",
                max_name_length = 18,
                max_prefix_length = 15,
                tab_size = 18,
                show_buffer_icons = ${boolToString cfg.bufferline.icons},
                show_buffer_close_icons = ${boolToString cfg.bufferline.showBufferClose},
                show_close_icon = true,
                show_tab_indicators = true,
                persist_buffer_sort = true,
                enforce_regular_tabs = false,
                always_show_bufferline = true,
                offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
                sort_by = "extension",
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                  local s = ""
                  for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and ""
                      or (e == "warning" and "" or "" )
                    if(sym ~= "") then
                      s = s .. " " .. n .. sym
                    end
                  end
                  return s
                end,
                numbers = function(opts)
                  return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
                end,
              }
            }
          '';
    })

    (mkIf cfg.indentBlankline.enable {
      vim.startPlugins = [ "indent-blankline" ];
      vim.luaConfigRC.indent-blankline =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("ibl").setup {
              indent = {
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
    (mkIf cfg.lualine.enable {
      vim.startPlugins = [ "lualine" ];
      vim.luaConfigRC.lualine =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require'lualine'.setup {
              options = {
                icons_enabled = ${boolToString cfg.lualine.icons},
                theme = "${toString cfg.lualine.theme}",
                component_separators = {
                  left = "${cfg.lualine.componentSeparator.left}",
                  right = "${cfg.lualine.componentSeparator.right}"
                },
                section_separators = {
                  left = "${cfg.lualine.sectionSeparator.left}",
                  right = "${cfg.lualine.sectionSeparator.right}"
                },
                disabled_filetypes = {},
              },
              sections = {
                lualine_a = ${cfg.lualine.activeSection.a},
                lualine_b = ${cfg.lualine.activeSection.b},
                lualine_c = ${cfg.lualine.activeSection.c},
                lualine_x = ${cfg.lualine.activeSection.x},
                lualine_y = ${cfg.lualine.activeSection.y},
                lualine_z = ${cfg.lualine.activeSection.z},
              },
              inactive_sections = {
                lualine_a = ${cfg.lualine.inactiveSection.a},
                lualine_b = ${cfg.lualine.inactiveSection.b},
                lualine_c = ${cfg.lualine.inactiveSection.c},
                lualine_x = ${cfg.lualine.inactiveSection.x},
                lualine_y = ${cfg.lualine.inactiveSection.y},
                lualine_z = ${cfg.lualine.inactiveSection.z},
              },
              tabline = {},
              extensions = {},
            }
          '';
    })
    (mkIf cfg.luatab.enable {
      vim.startPlugins = [ "luatab" ];
      vim.luaConfigRC.luatab =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("luatab").setup{}
          '';
    })
    (mkIf cfg.noice.enable {
      vim.startPlugins = [
        "noice"
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
                progress = {
                  enabled = false,
                },
                override = {
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                  ["vim.lsp.util.stylize_markdown"] = true,
                  ["cmp.entry.get_documentation"] = true,
                },
                signature = {
                  enabled = false,
                },
                message = {
                  enabled = false,
                },
              },
              presets = {
                bottom_search = ${boolToString cfg.noice.presets.bottomSearch},
                command_palette = ${boolToString cfg.noice.presets.commandPalette},
                inc_rename = ${boolToString cfg.noice.presets.incRename},
                long_message_to_split = ${boolToString cfg.noice.presets.longMessageToSplit},
                lsp_doc_border = ${boolToString cfg.noice.presets.lspDocBorder},
              },
            })

            require("notify").setup({
              background_colour = "#00000000"
            })
          '';
    })
    (mkIf cfg.nvimWebDevicons.enable {
      vim.startPlugins = [ "nvim-web-devicons" ];
    })
    (mkIf cfg.ranger.enable {
      vim.startPlugins = [ "ranger" ];
      vim.luaConfigRC.ranger =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("ranger-nvim").setup({ replace_netrw = true })
                vim.api.nvim_set_keymap("n", "<leader>ef", "", {
                  noremap = true,
                  callback = function()
                    require("ranger-nvim").open(true)
                  end,
                })
          '';
    })
    (mkIf cfg.theme.enable {
      vim.startPlugins = [ "theme" ];
      vim.luaConfigRC.nightfox =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require('nightfox').setup({
              options = {
                transparent = true,
                styles = {
                  comments = "italic",
                  strings = "italic",
                },
              },
              palettes = {
                nightfox = {
                  bg0 = "None",
                  bg1 = "None",
                  bg2 = "None",
                  bg3 = "None",
                  bg4 = "None",
                  sel0 = "None",
                  sel1 = "#3c5372",
                },
              },
              groups = {
                nightfox = {
                  WinSeperator = { fg = "None" },
                  NormalFloat = { bg = "None" },
                  StatusLine = { bg = "None" },
                  StatusLineNC = { bg = "None" },
                  TabLineFill = { bg = "None" },
                  WinBarNC = { bg = "None" },
                  Visual = { bg = "#3c5372" },
                },
              },
            })
            vim.cmd("colorscheme nightfox")
          '';
    })
    (mkIf cfg.todo.enable {
      vim.startPlugins = [ "todo" ];
      vim.luaConfigRC.todo =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("todo-comments").setup{}
          '';
    })
    (mkIf cfg.undo.enable {
      vim.startPlugins = [ "undotree" ];
      vim.luaConfigRC.todo =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require('undotree').setup()
            vim.api.nvim_set_keymap('n', '<leader>u', ':lua require("undotree").toggle()<CR>', {noremap = true, silent = true})
          '';
    })
  ]);
}
