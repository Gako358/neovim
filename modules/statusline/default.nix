{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.statusline.lualine;
in {
  options.vim.statusline.lualine = {
    enable = mkEnableOption "lualine";

    icons = mkOption {
      description = "Enable icons for lualine";
      type = types.bool;
      default = true;
    };

    theme = mkOption {
      description = "Theme for lualine";
      type = types.str;
      default = "borealis";
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

  config = mkIf cfg.enable {
    vim.startPlugins = ["lualine"];
    vim.luaConfigRC.lualine =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require'lualine'.setup {
          options = {
            icons_enabled = ${boolToString cfg.icons},
            theme = "${cfg.theme}",
            component_separators = {
              left = "${cfg.componentSeparator.left}",
              right = "${cfg.componentSeparator.right}"
            },
            section_separators = {
              left = "${cfg.sectionSeparator.left}",
              right = "${cfg.sectionSeparator.right}"
            },
            disabled_filetypes = {},
          },
          sections = {
            lualine_a = ${cfg.activeSection.a},
            lualine_b = ${cfg.activeSection.b},
            lualine_c = ${cfg.activeSection.c},
            lualine_x = ${cfg.activeSection.x},
            lualine_y = ${cfg.activeSection.y},
            lualine_z = ${cfg.activeSection.z},
          },
          inactive_sections = {
            lualine_a = ${cfg.inactiveSection.a},
            lualine_b = ${cfg.inactiveSection.b},
            lualine_c = ${cfg.inactiveSection.c},
            lualine_x = ${cfg.inactiveSection.x},
            lualine_y = ${cfg.inactiveSection.y},
            lualine_z = ${cfg.inactiveSection.z},
          },
          tabline = {},
        }
      '';
  };
}
