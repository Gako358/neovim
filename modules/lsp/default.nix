  { pkgs, config, lib, ...}:
  with lib;
  with builtins;

  let
    cfg = config.vim.lsp;
  in {
    options.vim.lsp = {
      enable = mkOption {
        type = types.bool;
        description = "enable lsp config [nvim-lspconfig]";
      };
    };

    config = mkIf cfg.enable {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-lspconfig
        nvim-lsp-installer
      ];

      vim.luaConfigRC = let
      in ''    
        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem = {
          documentationFormat = {
            "markdown",
            "plaintext",
          },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = {
            valueSet = { 1 },
          },
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        }
        
        -- Add neovim built-in Lua library into lsp runtime path.
        local neovim_lua_runtime_settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        }
        
        -- Setup border for the floating window
        local handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
          }),
        
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "single",
          }),
        }
        
        -- Setup diagnostic icons and signs
        vim.diagnostic.config({
          virtual_text = {
            prefix = "﮿",
            spacing = 4,
            source = "always",
          },
          signs = true,
          underline = true,
          -- update diagnostic in insert mode will be annoying when the output is too verbose
          update_in_insert = false,
        })
        
        local signs = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        }
        
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, {
            text = icon,
            texthl = hl,
            numhl = "",
          })
        end
        
        -- [[ =================================================================================
        --  LSP SETUP MAIN LOGIC
        -- =================================================================================]]
        
        require("nvim-lsp-installer").setup({
          -- only ensure Lua language server is installed
          automatic_installation = true,
          ui = {
            icons = {
              server_installed = "✓",
              server_pending = "➜",
              server_uninstalled = "✗",
            },
          },
        })
        
        -- Preconfigured language server that will be **automatically** installed.
        --
        -- WARNING: rust-analyzer is set up by plugin "rust-tools.nvim", *DONT*
        -- configured it manually here.
        --
        -- User might define same server for multiple filetype, so here we use Set data structure
        -- for unique value.
        --
        -- always enable sumneko_lua for Lua developing
        local server_set = {
          sumneko_lua = 0,
        }
        
        -- IF
        --   * we have a custom.lua file
        --   * custom.lua file return a table which contains `langs` field
        --   * the `langs` field has a Lua table value
        --   * and the size of the `langs` field is not zero
        -- THEN
        --   we install and configure those language server
        if have_custom and custom.langs and type(custom.langs) == "table" and #custom.langs > 0 then
          -- Insert a value into table if it is not presented in that table
          -- @field server: string
          function server_set:push(server)
            if self[server] == nil then
              self[server] = 0
            end
          end
        
          for _, lang in ipairs(custom.langs) do
            -- { "language filetype", "language server" }
            if type(lang) == "table" and #lang > 1 then
              -- lua 5.1 doesn't have continue keyword, so we have to write nested if block
              server_set:push(lang[2])
            end
          end
        
          server_set.push = nil
        end
        
        -- Attach the above settings to all the lspservers. And tell the nvim-lsp-installer to
        -- install those servers when necessary.
        for lspserver, _ in pairs(server_set) do
          local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = vim.loop.cwd,
            handlers = handlers,
          }
        
          if lspserver == "sumneko_lua" then
            opts.settings = neovim_lua_runtime_settings
          end
        
          lspconfig[lspserver].setup(opts)
          vim.cmd([[ do User LspAttachBuffers ]])
        end
    '';
  };
}
