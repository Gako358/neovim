{ pkgs, lib ? pkgs.lib, config, ...}:
let
  neovimPlugins = pkgs.neovimPlugins;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [../modules]; }
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
