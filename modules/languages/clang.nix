{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.clang;

  defaultServer = "ccls";
  servers = {
    ccls = {
      package = pkgs.ccls;
      lspConfig = ''
        lspconfig.ccls.setup{
          capabilities = capabilities;
          on_attach = attach_keymaps,
          cmd = {"${pkgs.ccls}/bin/ccls"};
          ${optionalString (cfg.lsp.opts != null) "init_options = ${cfg.lsp.cclsOpts}"}
        }
      '';
    };
  };

  defaultFormat = "clang-format";
  formats = {
    clang-format = {
      package = pkgs.clang-tools;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.clang_format.with({
            command = "${cfg.format.package}/bin/clang-format";
            filetypes = {"c", "cpp", "cs", "*.h", "*.hpp", "*.cc"};
          })
        )
      '';
    };
  };
in {
  options.vim.languages.clang = {
    enable = mkEnableOption "C/C++ language support";

    cHeader = mkOption {
      description = ''
        C syntax for headers. Can fix treesitter errors, see:
        https://www.reddit.com/r/neovim/comments/orfpcd/question_does_the_c_parser_from_nvimtreesitter/
      '';
      type = types.bool;
      default = false;
    };

    treesitter = {
      enable = mkOption {
        description = "Enable C/C++ treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      cPackage = nvim.types.mkGrammarOption pkgs "c";
      cppPackage = nvim.types.mkGrammarOption pkgs "cpp";
    };

    lsp = {
      enable = mkOption {
        description = "Enable clang LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "The clang LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "clang LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
      opts = mkOption {
        description = "Options to pass to clang LSP server";
        type = with types; nullOr str;
        default = null;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Clang formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "C formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Clang formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.cHeader {
      vim.configRC.c-header = nvim.dag.entryAnywhere "let g:c_syntax_for_h = 1";
    })

    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.cPackage cfg.treesitter.cppPackage];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;

      vim.lsp.lspconfig.sources.clang-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.clang-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
