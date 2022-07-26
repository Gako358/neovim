{
  description = "MerrinX's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rnix-lsp.url = "github:nix-community/rnix-lsp";

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
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
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

    # Tools
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };


  };

  outputs = { self, nixpkgs, neovim, rnix-lsp, ... }@inputs:
  let
    plugins = [
      "github-theme"
      "plenary-nvim"
      "nvim-lspconfig"
      "nvim-treesitter"
      "nvim-cmp"
      "cmp-buffer"
      "cmp-nvim-lsp"
      "cmp-vsnip"
      "cmp-path"
      "cmp-treesitter"
      "null-ls"
      "rust-tools"

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
          vim.theme.github-theme.enable = true;

          vim.lsp.enable = true;
          vim.lsp.rust = true;
          vim.lsp.lua = true;
          vim.lsp.python = true;
          vim.lsp.bash = true;
          vim.lsp.clang = true;
          vim.lsp.nix = true;
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
