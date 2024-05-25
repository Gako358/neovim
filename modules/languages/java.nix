{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.java;

  defaultServer = "jdtls";
  servers = {
    jdtls = {
      package = pkgs.jdt-language-server;
      lspConfig =
        /*
        lua
        */
        ''
          local home = os.getenv("HOME")
          local jdtls = require("jdtls")
          local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
          local root_dir = require("jdtls.setup").find_root(root_markers)

          -- If root_dir is nil, use current working directory
          if root_dir == nil then
            root_dir = vim.fn.getcwd()
          end

          local workspace_folder = home .. "/.cache/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

          -- Setting up root_dir
          local function get_root_dir()
            return lspconfig.util.root_pattern(unpack(root_markers))(vim.fn.expand('%:p:h'))
          end

          local jdtls_config_dir = home .. "/.config/jdtls_config"
          os.execute("mkdir -p " .. jdtls_config_dir)

          -- Copy from nix store to config dir
          os.execute("cp -r ${cfg.lsp.package}/config_linux/* " .. jdtls_config_dir)

          -- Debuging
          local bundles = {}
          local debug_bundles = vim.split(vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/*.jar"), "\n")
          local test_bundles = vim.split(vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar"), "\n")
          vim.list_extend(bundles, debug_bundles)
          -- vim.list_extend(bundles, test_bundles) TODO: Need to look into

          java_on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
            local opts = { noremap=true, silent=true, buffer = bufnr }
            vim.keymap.set("n", "<leader>jo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
            vim.keymap.set("n", "<leader>jrv", "<Cmd>lua require'jdtls'.extract_variable()<CR>", opts)
            vim.keymap.set("x", "<leader>jrv", "<Esc><Cmd>lua require'jdtls'.extract_variable(true)<CR>", opts)
            vim.keymap.set("n", "<leader>jrc", "<Cmd>lua require'jdtls'.extract_constant()<CR>", opts)
            vim.keymap.set("x", "<leader>jrc", "<Esc><Cmd>lua require'jdtls'.extract_constant(true)<CR>", opts)
            vim.keymap.set("x", "<leader>jrm", "<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>", opts)

            -- Set autocommands conditional on server_capabilities
            vim.lsp.codelens.refresh()
          end

          local config = {
            flags = {
              allow_incremental_sync = true,
            };
            capabilities = capabilities,
            on_attach = java_on_attach,
          };

          config.settings = {
            java = {
              referencesCodeLens = {enabled = true};
              signatureHelp = { enabled = true };
              implementationsCodeLens = { enabled = true };
              contentProvider = { preferred = 'fernflower' };
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*"
                }
              };
              sources = {
                organizeImports = {
                  starThreshold = 9999;
                  staticStarThreshold = 9999;
                };
              };
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-17",
                    path = "${pkgs.jdk17}/lib/openjdk/",
                  },
                  {
                    name = "JavaSE-21",
                    path = "${pkgs.jdk21}/lib/openjdk/",
                  },
                }
              };
            };
          };
          config.cmd = {
            "${cfg.lsp.package}/bin/jdtls",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Dosgi.sharedConfiguration.area=${pkgs.jdt-language-server}/share/config",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            "-configuration", jdtls_config_dir,
            "-data", workspace_folder,
          };
          config.root_dir = get_root_dir()
          config.on_init = function(client, _)
            client.notify('workspace/didChangeConfiguration', { settings = config.settings })
          end

          local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
          extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
          config.init_options = {
            bundles = bundles,
            extendedClientCapabilities = extendedClientCapabilities;
          };
          config.filetypes = {"java"};
          local nvim_jdtls_group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })

          vim.api.nvim_create_autocmd(
            "FileType",
            {
              pattern = { "java" },
              callback = function()
                jdtls.start_or_attach(config)
                jdtls.setup_dap({ hotcodereplace = "auto" })
                -- jdtls.dap.setup_dap_main_class_configs() TODO: return a nil
              end,
              group = nvim_jdtls_group,
            }
          )
        '';
    };
  };

  defaultFormat = "google-java-format";
  formats = {
    google-java-format = {
      package = pkgs.google-java-format;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.google_java_format.with({
            command = "${cfg.format.package}/bin/google-java-format";
            args = {
              "--aosp",
              "--skip-sorting-imports",
              "--skip-removing-unused-imports",
            };
          })
        )
      '';
    };
  };
in {
  options.vim.languages.java = {
    enable = mkEnableOption "Java language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Java treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "java";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Java LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Java LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Java LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Java formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Java formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Java formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };

    debug = {
      enable = mkOption {
        description = "Enable Java debugging";
        type = types.bool;
        default = config.vim.languages.enableDebug;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })

    (mkIf cfg.lsp.enable {
      vim.startPlugins = ["nvim-jdtls"];
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.java-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.java-format = formats.${cfg.format.type}.nullConfig;
    })

    (mkIf cfg.debug.enable {
      vim.debug.enable = true;
    })
  ]);
}
