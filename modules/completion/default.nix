{
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.autocomplete;
  debugEnabled = config.vim.debug.enable;

  builtSources =
    concatMapStringsSep
    "\n"
    (n: "{ name = '${n}'},")
    (attrNames cfg.sources);

  builtMaps =
    concatStringsSep
    "\n"
    (mapAttrsToList
      (n: v:
        if v == null
        then ""
        else "${n} = '${v}',")
      cfg.sources);

  dagPlacement = nvim.dag.entryAnywhere;
in {
  options.vim = {
    autocomplete = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable autocomplete";
      };

      type = mkOption {
        type = types.enum ["nvim-cmp"];
        default = "nvim-cmp";
        description = "Set the autocomplete plugin. Options: [nvim-cmp]";
      };

      sources = mkOption {
        description = ''
          Attribute set of source names for nvim-cmp.

          If an attribute set is provided, then the menu value of
          `vim_item` in the format will be set to the value (if
          utilizing the `nvim_cmp_menu_map` function).

          Note: only use a single attribute name per attribute set
        '';
        type = with types; attrsOf (nullOr str);
        default = {};
        example = ''
          {nvim-cmp = null; buffer = "[Buffer]";}
        '';
      };

      formatting = {
        format = mkOption {
          description = ''
            The function used to customize the appearance of the completion menu.

            Default is to call the menu mapping function.
          '';
          type = types.str;
          default = "nvim_cmp_menu_map";
          example = ''
            ```lua
            function(entry, vim_item)
              return vim_item
            end
            ```
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins =
      [
        "nvim-cmp"
        "cmp-buffer"
        "cmp-vsnip"
        "cmp-path"
      ]
      ++ optional debugEnabled "cmp-dap";

    vim.autocomplete.sources = {
      "nvim-cmp" = null;
      "vsnip" = "[VSnip]";
      "buffer" = "[Buffer]";
      "crates" = "[Crates]";
      "path" = "[Path]";
    };

    vim.luaConfigRC.completion = mkIf (cfg.type == "nvim-cmp") (dagPlacement
      /*
      lua
      */
      ''
        local nvim_cmp_menu_map = function(entry, vim_item)
          -- name for each source
          vim_item.menu = ({
            ${builtMaps}
          })[entry.source.name]
          print(vim_item.menu)
          return vim_item
        end

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local feedkey = function(key, mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end

        local cmp = require'cmp'
        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          sources = {
            ${builtSources}
          },
          mapping = {
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c'}),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c'}),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({
              select = true,
            }),
            ['<Tab>'] = cmp.mapping(function (fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.fn['vsnip#available'](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function (fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.fn['vsnip#available'](-1) == 1 then
                feedkeys("<Plug>(vsnip-jump-prev)", "")
              end
            end, { 'i', 's' })
          },
          completion = {
            completeopt = 'menu,menuone,noinsert',
          },
          formatting = {
            format = ${cfg.formatting.format},
          },
          ${optionalString debugEnabled ''
          enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
              or require("cmp_dap").is_dap_buffer()
          end,
        ''}
        })

        ${optionalString (config.vim.visuals.autopairs.enable && config.vim.visuals.autopairs.type == "nvim-autopairs") ''
          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { text = ""} }))
        ''}

        ${optionalString debugEnabled ''
          cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = { name = "dap" };
          })
        ''}
      '');

    vim.snippets.vsnip.enable =
      if (cfg.type == "nvim-cmp")
      then true
      else config.vim.snippets.vsnip.enable;
  };
}
