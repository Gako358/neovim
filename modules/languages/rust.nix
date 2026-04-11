{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.rust;

  defaultFormat = "rustfmt";
  formats = {
    rustfmt = {
      package = pkgs.rustfmt;
      nullConfig =
        /*
        lua
        */
        ''
          table.insert(
            ls_sources,
            null_ls.builtins.formatting.rustfmt.with({
              command = "${cfg.format.package}/bin/rustfmt";
            })
          )
        '';
    };
  };
in
{
  options.vim.languages.rust = {
    enable = mkEnableOption "Rust language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Rust treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "rust";
    };

    crates = {
      enable = mkEnableOption "crates-nvim, tools for managing dependencies";
      codeActions = mkOption {
        description = "Enable code actions through null-ls";
        type = types.bool;
        default = true;
      };
    };

    lsp = {
      enable = mkOption {
        description = "Rust LSP support (rust-analyzer with extra tools)";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      package = mkOption {
        description = "rust-analyzer package";
        type = types.package;
        default = pkgs.rust-analyzer;
      };
      opts = mkOption {
        description = "Options to pass to rust analyzer";
        type = types.str;
        default = "";
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Rust formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Rust formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Rust formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.crates.enable {
      vim.startPlugins = [ "crates-nvim" ];

      vim.autocomplete.cmp.sources = { "crates" = "[Crates]"; };
      vim.luaConfigRC.rust-crates = nvim.dag.entryAnywhere ''
        require('crates').setup {
          completion = {
            cmp = {
              enabled = true,
            },
          },
        }
      '';
    })
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })
    (mkIf cfg.lsp.enable {
      vim.startPlugins = [ "rustaceanvim" ];

      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.rust-lsp =
        /*
        lua
        */
        ''
          vim.g.rustaceanvim = {
            server = {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                default_on_attach(client, bufnr)
                local opts = { noremap=true, silent=true, buffer = bufnr }
                vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp('runnables') end, opts)
                vim.keymap.set("n", "<leader>rp", function() vim.cmd.RustLsp('parentModule') end, opts)
                vim.keymap.set("n", "<leader>rm", function() vim.cmd.RustLsp('expandMacro') end, opts)
                vim.keymap.set("n", "<leader>rc", function() vim.cmd.RustLsp('openCargo') end, opts)
                vim.keymap.set("n", "<leader>rd", function() vim.cmd.RustLsp('debuggables') end, opts)
                vim.keymap.set("n", "<leader>re", function() vim.cmd.RustLsp('explainError') end, opts)
              end,
              cmd = {"${cfg.lsp.package}/bin/rust-analyzer"},
              default_settings = {
                ["rust-analyzer"] = {
                  ${cfg.lsp.opts}
                }
              }
            }
          }
        '';
    })
    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.rust-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
