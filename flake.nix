{
  description = "MerrinX's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
        # LSP plugins
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig?ref=v0.1.3";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    lspsaga = {
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:lewis6991/nvim-treesitter-context";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };

    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    sqls-nvim = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    # Copying/Registers
    registers = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    nvim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";

    # Filetrees
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # Tablines
    nvim-bufferline-lua = {
      url = "github:akinsho/nvim-bufferline.lua?ref=v1.2.0";
      flake = false;
    };

    # Statuslines
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # Autocompletes
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # snippets
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    # Autopairs
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    # Commenting
    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    # Buffer tools
    bufdelete-nvim = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };

    # Themes
    nord-vim = {
      url = "github:arcticicestudio/nord-vim";
      flake = false;
    };

    # Rust crates
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };

    # Visuals
    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # Key binding help
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # Plenary (required by crates-nvim)
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    hare-vim = {
      url = "git+https://git.sr.ht/~sircmpwn/hare.vim";
      flake = false;
    };

    tree-sitter-hare = {
      url = "git+https://git.sr.ht/~ecmma/tree-sitter-hare";
      flake = false;
    };
  };


  outputs = { self, nixpkgs, neovim, rnix-lsp, ... }@inputs:
  let
    plugins = [
      "nord-vim"
      "vim-startify"
      "nvim-lspconfig"
      "nvim-dap"
      "nvim-telescope"
      "popup-nvim"
      "plenary-nvim"
      "nvim-web-devicons"
      "nvim-tree-lua"
      "telescope-dap"
      "vimagit"
      "fugitive" 
      "nvim-lightbulb"
      "nvim-treesitter"
      "nvim-treesitter-context"
      "editorconfig-vim"
      "indent-blankline-nvim"
      "indentline"
      "nvim-blame-line"
      "nvim-dap-virtual-text"
      "vim-cursorword"
      "vim-test"
      "nvim-which-key"
    ];

    externalBitsOverlay = top: last: {
      rnix-lsp = rnix-lsp.defaultPackage.${top.system};
      neovim-nightly = neovim.defaultPackage.${top.system};
    };

    pluginOverlay = top: last: let
      buildPlug = name: top.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = builtins.getAttr name inputs;
      };
    in {
      neovimPlugins = builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);
    };
    
    allPkgs = lib.mkPkgs { 
      inherit nixpkgs; 
      cfg = { };
      overlays = [
        pluginOverlay
        externalBitsOverlay
      ];
    };

    lib = import ./lib;

    mkNeoVimPkg = pkgs: lib.neovimBuilder {
        inherit pkgs;
        config = {
          vim.viAlias = true;
          vim.vimAlias = true;
          vim.dashboard.startify.enable = true;
          vim.dashboard.startify.customHeader = [ "NIXOS NEOVIM CONFIG" ];
          vim.theme.nord.enable = true;
          vim.disableArrows = true;
          vim.statusline.lightline.enable = true;
          vim.lsp.enable = true;
          vim.lsp.bash = true;
          vim.lsp.go = true;
          vim.lsp.nix = true;
          vim.lsp.python = true;
          vim.lsp.ruby = true;
          vim.lsp.rust = true;
          vim.lsp.terraform = true;
          vim.lsp.typescript = true;
          vim.lsp.vimscript = true;
          vim.lsp.yaml = true;
          vim.lsp.docker = true;
          vim.lsp.tex = true;
          vim.lsp.css = true;
          vim.lsp.html = true;
          vim.lsp.json = true;
          vim.lsp.clang = true;
          vim.lsp.variableDebugPreviews = true;
          vim.fuzzyfind.telescope.enable = true;
          vim.filetree.nvimTreeLua.enable = true;
          vim.git.enable = true;
          vim.formatting.editorConfig.enable = true;
          vim.editor.indentGuide = true;
          vim.editor.underlineCurrentWord = true;
          vim.test.enable = true;
        };
      };

  in {

    apps = lib.withDefaultSystems (sys:
    {
      nvim = {
        type = "app";
        program = "${self.defaultPackage."${sys}"}/bin/nvim";
      };
    });

    defaultApp = lib.withDefaultSystems (sys: {
      type = "app";
      program = "${self.defaultPackage."${sys}"}/bin/nvim";
    });

    defaultPackage = lib.withDefaultSystems (sys: self.packages."${sys}".neovimWT);

    packages = lib.withDefaultSystems (sys: {
      neovimWT = mkNeoVimPkg allPkgs."${sys}";
    });
  };
}
