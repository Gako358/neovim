{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.autocomplete;
in {
  options.vim.autocomplete = {
    enable = mkOption {
      type = types.bool;
      description = "enable autocomplete plugin: [nvim-cmp]";
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
        github-copilot
        nvim-comment
        nvim-cmp
        luasnip
        cmp-nvim-lsp
        cmp-path
        cmp-buffer
        cmp-luasnip
        cmp-treesitter
      ];

      vim.luaConfigRC = ''

        -----------------------------------------------------------
        -- Copilot Management
        -----------------------------------------------------------
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

        local cmp = require 'cmp'
        local luasnip = require 'luasnip'

        require("luasnip/loaders/from_vscode").lazy_load()
        require('nvim_comment').setup()
        
        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        
        local kind_icons = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
          VimCmdLine = "",
        }
        
        local source_menu = {
          buffer = "[﬘ Buf]",
          nvim_lsp = "[ LSP]",
          luasnip = "[ LSnip]",
          nvim_lua = "[ NvimLua]",
          crates = "[ Crates]",
          latex_symbols = "[ Latex]",
          dictionary = "[韛Dict]",
        }
        
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          style = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
          window = {
            completion = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              scrollbar = "║",
              autocomplete = {
                require("cmp.types").cmp.TriggerEvent.InsertEnter,
                require("cmp.types").cmp.TriggerEvent.TextChanged,
              },
            },
            documentation = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
              scrollbar = "║",
            },
          },
          formatting = {
            format = function(entry, item)
              -- return special icon for cmdline completion
              if entry.source.name == "cmdline" then
                item.kind = string.format("%s %s", kind_icons["VimCmdLine"], "Vim")
                return item
              end
              item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
              item.menu = (source_menu)[entry.source.name]
              return item
            end,
          },
          mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {
              "i",
              "c",
            }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {
              "i",
              "c",
            }),
            ["<C-e>"] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
              end
            end, { "i", "s" }),
        
            ["<S-Tab>"] = cmp.mapping(function()
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { "i", "s" }),
          },
          sources = {
            { name = "nvim_lsp"},
            { name = "crates"},
            { name = "treesitter"},
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
            { name = "dictionary", keyword_length = 2 },
          },
          experimental = {
            ghost_text = true,
          },
        })
        
        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            {
              name = "buffer",
            },
          },
        })
        
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        }) 
      '';
    }
  );
}
        
