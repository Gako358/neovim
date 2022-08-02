{
  description = "MerrinX's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Vim plugins ###

    # Theme
    github-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };

    # Plenary
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # LSP
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    # COPILOT
    github-copilot = {
      url = "github:github/copilot.vim";
      flake = false;
    };

    # CMP
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    lightspeed = {
      url = "github:ggandor/lightspeed.nvim";
      flake = false;
    };
    nvim-comment = {
      url = "github:terrortylor/nvim-comment";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # CORE PLUGINS
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    nvim-bufferline = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };
    nvim-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    # FILETREE
    nvim-filetree = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # TELESCOPE
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, neovim, ... }@inputs:
  let
    plugins = [
      "github-theme"
      "plenary-nvim"
      "nvim-treesitter"
      "nvim-lspconfig"
      "github-copilot"
      "nvim-cmp"
      "luasnip"
      "cmp-nvim-lsp"
      "cmp-path"
      "cmp-buffer"
      "cmp-luasnip"
      "lightspeed"
      "nvim-comment"
      "cmp-treesitter"
      "nvim-autopairs"
      "web-devicons"
      "nvim-bufferline"
      "nvim-gitsigns"
      "lualine"
      "indent-blankline"
      "nvim-filetree"
      "telescope"
    ];

    externalBitsOverlay = top: last: {
      neovim-nightly = neovim.defaultPackage.${top.system};
    };

    pluginOverlay = top: last: let
      treesitterGrammars = last.tree-sitter.withPlugins (p: [
        p.tree-sitter-c
        p.tree-sitter-nix
        p.tree-sitter-python
        p.tree-sitter-rust
        p.tree-sitter-markdown
        p.tree-sitter-comment
        p.tree-sitter-toml
        p.tree-sitter-make
        p.tree-sitter-html
        p.tree-sitter-javascript
        p.tree-sitter-css
      ]);
      buildPlug = name: top.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = builtins.getAttr name inputs;
        postPatch =
        if (name == "nvim-treesitter")
        then ''
          rm -r parser
          ln -s ${treesitterGrammars} parser
        ''
        else "";
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

    lib = 
      import 
      ./lib;

    mkNeoVimPkg = pkgs: lib.neovimBuilder {
        inherit pkgs;
        config = {
          vim.viAlias = true;
          vim.vimAlias = true;
          vim.autoIndent = true;
          vim.theme.github-theme.enable = true;

          vim.treesitter.enable = true;
          vim.lsp.enable = true;
          vim.lsp.python = true;
          vim.lsp.clang = true;
          vim.lsp.bash = true;
          vim.lsp.lua = true;
          vim.lsp.nix = true;
          vim.lsp.rust = true;
          vim.lsp.typescript = true;

          vim.autocomplete.enable = true;

          vim.autopairs.enable = true;
          vim.filetree.enable = true;
          vim.bufferline.enable = true;
          vim.lualine.enable = true;
          vim.gitsigns.enable = true;
          vim.blanklines.enable = true;

          vim.telescope.enable = true;
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

    defaultPackage = lib.withDefaultSystems (sys: self.packages."${sys}".neovimMX);

    packages = lib.withDefaultSystems (sys: {
      neovimMX = mkNeoVimPkg allPkgs."${sys}";
    });
  };
}
