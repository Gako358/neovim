with builtins;
rec {
  defaultSystems = [
    "aarch64-linux"
    "aarch64-darwin"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  # Taken from flake-utils
  # List of all systems defined in nixpkgs
  # Keep in sync with nixpkgs wit the following command:
  # $ nix-instantiate --json --eval --expr "with import <nixpkgs> {}; lib.platforms.all" | jq
  allSystems = [
    "aarch64-linux"
    "armv5tel-linux"
    "armv6l-linux"
    "armv7a-linux"
    "armv7l-linux"
    "mipsel-linux"
    "i686-cygwin"
    "i686-freebsd"
    "i686-linux"
    "i686-netbsd"
    "i686-openbsd"
    "x86_64-cygwin"
    "x86_64-freebsd"
    "x86_64-linux"
    "x86_64-netbsd"
    "x86_64-openbsd"
    "x86_64-solaris"
    "x86_64-darwin"
    "i686-darwin"
    "aarch64-darwin"
    "armv7a-darwin"
    "x86_64-windows"
    "i686-windows"
    "wasm64-wasi"
    "wasm32-wasi"
    "x86_64-redox"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
    "arm-none"
    "armv6l-none"
    "aarch64-none"
    "avr-none"
    "i686-none"
    "x86_64-none"
    "powerpc-none"
    "msp430-none"
    "riscv64-none"
    "riscv32-none"
    "vc4-none"
    "js-ghcjs"
    "aarch64-genode"
    "x86_64-genode"
  ];

  evalMods = {allPkgs, systems ? defaultSystems, modules, args ?{}}: withSystems systems (sys: let
    pkgs = allPkgs."${sys}";
  in pkgs.lib.evalModules {
    inherit modules;
    specialArgs = { inherit pkgs;} // args;
  });

  mkPkgs = {nixpkgs, systems ? defaultSystems, cfg ? {}, overlays ? []}: withSystems systems (sys: 
  import nixpkgs { 
    system = sys; 
    config = cfg; 
    overlays = overlays; 
  });

  withDefaultSystems = withSystems defaultSystems;
  withSystems = systems: f: foldl' (cur: nxt:
  let
    ret = {
      "${nxt}" = f nxt;
    };
  in cur // ret) {} systems;

  neovimBuilder = {pkgs, config, ...}: let
    neovimPlugins = pkgs.neovimPlugins;
    vimOptions = pkgs.lib.evalModules {
      modules = [
        { imports = [ ../modules]; }
        config
      ];

      specialArgs = {
        inherit pkgs;
      };
    };

    vim = vimOptions.config.vim;
  in pkgs.wrapNeovim pkgs.neovim-nightly {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = vim.configRC;

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  };

  buildPluginOverlay = super: self:
    let
      inherit (builtins) attrNames filter listToAttrs;
      inherit (self.vimUtils) buildVimPluginFrom2Nix;

      treesitterGrammars = self.tree-sitter.withPlugins (p: with p; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-commonlisp
        tree-sitter-css
        tree-sitter-dockerfile
        tree-sitter-elisp
        tree-sitter-elixir
        tree-sitter-erlang
        tree-sitter-fish
        tree-sitter-haskell
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-json
        tree-sitter-latex
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-typescript
        tree-sitter-vue
        tree-sitter-yaml
      ]);

      buildPlug = name: buildVimPluginFrom2Nix {
        pname = name;
        version = "HEAD";
        src = builtins.getAttr name inputs;
        postPatch =
          if (name == "nvim-treesitter")
          then ''
            rm -r parser
            ln -s ${treesitterGrammars} parser
          ''
          else "";
      };

      isPlugin = n: n != "neovim" && n != "nixpkgs";

      plugins = filter isPlugin (attrNames inputs);
    in
    {
      neovimPlugins = listToAttrs
        (map
          (name: {
            inherit name;
            value = buildPlug name;
          })
          plugins);
    };
}
