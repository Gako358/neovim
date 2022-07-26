{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.lsp;

  debugpy = pkgs.python3.withPackages (pyPkg: with pyPkg; [ debugpy ]);
in {

  options.vim.lsp = {
    enable = mkEnableOption "Enable lsp support";

    bash = mkEnableOption "Enable Bash Language Support";
    go = mkEnableOption "Enable Go Language Support";
    nix = mkEnableOption "Enable NIX Language Support";
    python = mkEnableOption "Enable Python Support";
    ruby = mkEnableOption "Enable Ruby Support";
    rust = mkEnableOption "Enable Rust Support";
    terraform = mkEnableOption "Enable Terraform Support";
    typescript = mkEnableOption "Enable Typescript/Javascript Support";
    vimscript = mkEnableOption "Enable Vim Script Support";
    yaml = mkEnableOption "Enable yaml support";
    docker = mkEnableOption "Enable docker support";
    tex = mkEnableOption "Enable tex support";
    css = mkEnableOption "Enable css support";
    html = mkEnableOption "Enable html support";
    clang = mkEnableOption "Enable C/C++ with clang";
    cmake = mkEnableOption "Enable CMake";
    json = mkEnableOption "Enable JSON";

    lightbulb = mkEnableOption "Enable Light Bulb";
    variableDebugPreviews = mkEnableOption "Enable variable previews";

  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ 
      nvim-lspconfig 
      completion-nvim 
      nvim-dap
      (if cfg.nix then vim-nix else null)
      telescope-dap
      (if cfg.lightbulb then nvim-lightbulb else null)
      (if cfg.variableDebugPreviews then nvim-dap-virtual-text else null)
      nvim-treesitter
      nvim-treesitter-context

    ];

    vim.configRC = ''
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      " Set completeopt to have a better completion experience
      set completeopt=menuone,noinsert,noselect

      ${if cfg.variableDebugPreviews then ''
        let g:dap_virtual_text = v:true
      '' else ""}

      let g:completion_enable_auto_popup = 2
    '';

    vim.nnoremap = {
      #"<f2>" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>cR" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>cr" = "<cmd>lua require'telescope.builtin'.lsp_references()<CR>";
      "<leader>ca" = "<cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>";

      "<leader>cd" = "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>";
      "<leader>ci" = "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>";
      #"<leader>e" = "<cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<cr>";
      #"<leader>E" = "<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>";
      "<leader>cf" = "<cmd>lua vim.lsp.buf.formatting()<CR>";
      "<leader>ck" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      #"<leader>K" = "<cmd>lua vim.lsp.buf.hover()<CR>";

      #"[d" = "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>";
      #"]d" = "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>";

      #"<leader>q" = "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>";

      "<leader>do" = "<cmd>lua require'dap'.step_over()<cr>";
      "<leader>ds" = "<cmd>lua require'dap'.step_into()<cr>";
      "<leader>dO" = "<cmd>lua require'dap'.step_out()<cr>";
      "<leader>dc" = "<cmd>lua require'dap'.continue()<cr>";
      "<leader>db" = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
      "<leader>dr" = "<cmd>lua require'dap'.repl.open()<cr>";

      #"<leader>d" = "<cmd>Telescope dap commands<cr>";
      #"<leader>B" = "<cmd>Telescope dap list_breakpoints<cr>";
      #"<leader>dv" = "<cmd>Telescope dap variables<cr>";
      #"<leader>df" = "<cmd>Telescope dap frames<cr>";
    };

    vim.globals = {
    };

    vim.luaConfigRC = ''
      local wk = require("which-key")
      wk.register({
        c = {
          name = "Code",
          a = {"Code Action"},
          f = {"Format"},
          d = {"Definitions"},
          i = {"Implementations"},
          R = {"Rename"},
          r = {"References"},
          k = {"Signature"},
        },
        d = {
          name = "Debug",
          o = {"Step Over"},
          s = {"Step Into"},
          O = {"Step Out"},
          c = {"Continue"},
          b = {"Toggle Break Point"},
          r = {"Debug Repl"},

        },
      },{ prefix = "<leader>" })

      local lspconfig = require'lspconfig'
      local dap = require'dap'

      --Tree sitter config
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = {},
        },
        rainbow = {
          enable = true,
          extended_mode = true,
        },
         autotag = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      }

      vim.cmd [[set foldmethod=expr]]
      vim.cmd [[set foldlevel=10]]
      vim.cmd [[set foldexpr=nvim_treesitter#foldexpr()]]

      ${if cfg.lightbulb then ''
        require'nvim-lightbulb'.update_lightbulb {
          sign = {
            enabled = true,
            priority = 10,
          },
          float = {
            enabled = false,
            text = "💡",
            win_opts = {},
          },
          virtual_text = {
            enable = false,
            text = "💡",

          },
          status_text = {
            enabled = false,
            text = "💡",
            text_unavailable = ""           
          }
        }

      '' else ""}

      ${if cfg.bash then ''
        lspconfig.bashls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
        }
      '' else ""}

      ${if cfg.go then ''
        lspconfig.gopls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.gopls}/bin/gopls"}
        } 

        dap.adapters.go = function(callback, config)
          local handle
          local pid_or_err
          local port = 38697
          handle, pid_or_err =
            vim.loop.spawn(
            "dlv",
            {
              args = {"dap", "-l", "127.0.0.1:" .. port},
              detached = true
            },
            function(code)
              handle:close()
              print("Delve exited with exit code: " .. code)
            end
          )
          -- Wait 100ms for delve to start
          vim.defer_fn(
            function()
              --dap.repl.open()
              callback({type = "server", host = "127.0.0.1", port = port})
            end,
            100)


          --callback({type = "server", host = "127.0.0.1", port = port})
        end
        -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
        dap.configurations.go = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${"$"}{workspaceFolder}"
          },
          {
            type = "go",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${"$"}{workspaceFolder}"
          },
       }


      '' else ""}

      ${if cfg.nix then ''
        lspconfig.rnix.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
        }
      '' else ""}

      ${if cfg.ruby then ''
        lspconfig.solargraph.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.solargraph}/bin/solargraph', 'stdio'}
        }
      '' else ""}

      ${if cfg.rust then ''
        lspconfig.rust_analyzer.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.rust-analyzer}/bin/rust-analyzer'}
        }
      '' else ""}

      ${if cfg.terraform then ''
        lspconfig.terraformls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.terraform-ls}/bin/terraform-ls', 'serve' }
        }
      '' else ""}

      ${if cfg.typescript then ''
        lspconfig.tsserver.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.vimscript then ''
        lspconfig.vimls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.yaml then ''
        lspconfig.vimls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.docker then ''
        lspconfig.dockerls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.css then ''
        lspconfig.cssls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver', '--stdio' };
          filetypes = { "css", "scss", "less" }; 
        }
      '' else ""}

      ${if cfg.html then ''
        lspconfig.html.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver', '--stdio' };
          filetypes = { "html", "css", "javascript" }; 
        }
      '' else ""}

      ${if cfg.json then ''
        lspconfig.jsonls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver', '--stdio' };
          filetypes = { "html", "css", "javascript" }; 
        }
      '' else ""}

      ${if cfg.tex then ''
        lspconfig.texlab.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.texlab}/bin/texlab'}
        }
      '' else ""}

      ${if cfg.clang then ''
        lspconfig.clangd.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.clang-tools}/bin/clangd', '--background-index'};
          filetypes = { "c", "cpp", "objc", "objcpp" };
        }
      '' else ""}

      ${if cfg.cmake then ''
        lspconfig.cmake.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.cmake-language-server}/bin/cmake-language-server'};
          filetypes = { "cmake"};
        }
      '' else ""}

      ${if cfg.python then ''
        lspconfig.pyright.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }

      '' else ""}

    '';
  };
}
