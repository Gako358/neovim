{
  config,
  lib,
  pkgs,
  currentModules,
  ...
}:
with lib;
with builtins; let
  cfgBuild = config.build;
  cfgBuilt = config.built;
  cfgVim = config.vim;
  cfg = config.vim;

  inputsSubmodule = {...}: {
    options.src = mkOption {
      description = "The plugin source";
      type = types.package;
    };
  };

  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';

  mkMappingOption = it:
    mkOption ({
        default = {};
        type = with types; attrsOf (nullOr str);
      }
      // it);
in {
  options = {
    build = {
      viAlias = mkOption {
        description = "Enable vi alias";
        type = types.bool;
        default = true;
      };

      vimAlias = mkOption {
        description = "Enable vim alias";
        type = types.bool;
        default = true;
      };

      rawPlugins = mkOption {
        description = "Plugins that are just the source, usually from a flake input";
        type = with types; attrsOf (submodule inputsSubmodule);
        default = {};
      };

      package = mkOption {
        description = "Neovim to use for neovim-flake";
        type = types.package;
        default = pkgs.neovim-unwrapped;
      };
    };

    built = {
      configRC = mkOption {
        description = "The final built config";
        type = types.lines;
        readOnly = true;
      };

      startPlugins = mkOption {
        description = "The final built start plugins";
        type = with types; listOf package;
        readOnly = true;
      };

      optPlugins = mkOption {
        description = "The final built opt plugins";
        type = with types; listOf package;
        readOnly = true;
      };

      package = mkOption {
        description = "The final wrapped and configured neovim package";
        type = types.package;
        readOnly = true;
      };
    };

    vim = {
      configRC = mkOption {
        description = "vimrc contents";
        type = nvim.types.dagOf types.lines;
        default = {};
      };

      luaConfigRC = mkOption {
        description = "vim lua config";
        type = nvim.types.dagOf types.lines;
        default = {};
      };

      startPlugins = nvim.types.pluginsOpt {
        rawPlugins = config.build.rawPlugins;
        default = [];
        description = "List of plugins to startup.";
      };

      optPlugins = nvim.types.pluginsOpt {
        rawPlugins = config.build.rawPlugins;
        default = [];
        description = "List of plugins to optionally load";
      };

      globals = mkOption {
        default = {};
        description = "Set containing global variable values";
        type = types.attrs;
      };

      nnoremap = mkMappingOption {description = "Defines 'Normal mode' mappings";};
      inoremap = mkMappingOption {description = "Defines 'Insert and Replace mode' mappings";};
      vnoremap = mkMappingOption {description = "Defines 'Visual and Select mode' mappings";};
      xnoremap = mkMappingOption {description = "Defines 'Visual mode' mappings";};
      snoremap = mkMappingOption {description = "Defines 'Select mode' mappings";};
      cnoremap = mkMappingOption {description = "Defines 'Command-line mode' mappings";};
      onoremap = mkMappingOption {description = "Defines 'Operator pending mode' mappings";};
      tnoremap = mkMappingOption {description = "Defines 'Terminal mode' mappings";};
      nmap = mkMappingOption {description = "Defines 'Normal mode' mappings";};
      imap = mkMappingOption {description = "Defines 'Insert and Replace mode' mappings";};
      vmap = mkMappingOption {description = "Defines 'Visual and Select mode' mappings";};
      xmap = mkMappingOption {description = "Defines 'Visual mode' mappings";};
      smap = mkMappingOption {description = "Defines 'Select mode' mappings";};
      cmap = mkMappingOption {description = "Defines 'Command-line mode' mappings";};
      omap = mkMappingOption {description = "Defines 'Operator pending mode' mappings";};
      tmap = mkMappingOption {description = "Defines 'Terminal mode' mappings";};
    };
  };

  config = let
    buildPlug = name:
      pkgs.vimUtils.buildVimPlugin rec {
        pname = name;
        version = "master";
        src = assert asserts.assertMsg (name != "nvim-treesitter") "Use buildTreesitterPlug for building nvim-treesitter.";
          cfgBuild.rawPlugins.${pname}.src;
      };

    treeSitterPlug = pkgs.vimPlugins.nvim-treesitter.withPlugins (_: config.vim.treesitter.grammars);

    buildConfigPlugins = plugins:
      map
      (plug: (
        if isString plug
        then
          (
            if (plug == "nvim-treesitter")
            then treeSitterPlug
            else buildPlug plug
          )
        else plug
      ))
      (filter
        (f: f != null)
        plugins);

    normalizedPlugins =
      cfgBuilt.startPlugins
      ++ (map (plugin: {
          inherit plugin;
          optional = true;
        })
        cfgBuilt.optPlugins);

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit (cfgBuild) viAlias vimAlias;
      plugins = normalizedPlugins;
      customRC = cfgBuilt.configRC;
    };

    # Vim config helpers
    mkVimBool = val: if val then "1" else "0";
    valToVim = val:
      if (isInt val)
      then (builtins.toString val)
      else
        (if (isBool val)
        then (mkVimBool val)
        else (toJSON val));

    filterNonNull = mappings: filterAttrs (name: value: value != null) mappings;
    globalsScript =
      mapAttrsFlatten (name: value: "let g:${name}=${valToVim value}")
      (filterNonNull cfg.globals);

    matchCtrl = it: match "Ctrl-(.)(.*)" it;
    mapKeyBinding = it: let
      groups = matchCtrl it;
    in
      if groups == null
      then it
      else "<C-${toUpper (head groups)}>${head (tail groups)}";
    mapVimBinding = prefix: mappings:
      mapAttrsFlatten (name: value: "${prefix} ${mapKeyBinding name} ${value}")
      (filterNonNull mappings);

    # Map bindings
    nmap = mapVimBinding "nmap" config.vim.nmap;
    imap = mapVimBinding "imap" config.vim.imap;
    vmap = mapVimBinding "vmap" config.vim.vmap;
    xmap = mapVimBinding "xmap" config.vim.xmap;
    smap = mapVimBinding "smap" config.vim.smap;
    cmap = mapVimBinding "cmap" config.vim.cmap;
    omap = mapVimBinding "omap" config.vim.omap;
    tmap = mapVimBinding "tmap" config.vim.tmap;

    nnoremap = mapVimBinding "nnoremap" config.vim.nnoremap;
    inoremap = mapVimBinding "inoremap" config.vim.inoremap;
    vnoremap = mapVimBinding "vnoremap" config.vim.vnoremap;
    xnoremap = mapVimBinding "xnoremap" config.vim.xnoremap;
    snoremap = mapVimBinding "snoremap" config.vim.snoremap;
    cnoremap = mapVimBinding "cnoremap" config.vim.cnoremap;
    onoremap = mapVimBinding "onoremap" config.vim.onoremap;
    tnoremap = mapVimBinding "tnoremap" config.vim.tnoremap;
  in {
    vim = {
      configRC = {
        globalsScript = nvim.dag.entryAnywhere (concatStringsSep "\n" globalsScript);

        luaScript = let
          mkSection = r: ''
            -- SECTION: ${r.name}
            ${r.data}
          '';
          mapResult = r: (wrapLuaConfig (concatStringsSep "\n" (map mkSection r)));
          luaConfig = nvim.dag.resolveDag {
            name = "lua config script";
            dag = cfg.luaConfigRC;
            inherit mapResult;
          };
        in
          nvim.dag.entryAfter ["globalsScript"] luaConfig;

        mappings = let
          maps = [nmap imap vmap xmap smap cmap omap tmap nnoremap inoremap vnoremap xnoremap snoremap cnoremap onoremap tnoremap];
          mapConfig = concatStringsSep "\n" (map (v: concatStringsSep "\n" v) maps);
        in
          nvim.dag.entryAfter ["globalsScript"] mapConfig;
      };
    };

    built = {
      configRC = let
        mkSection = r: ''
          " SECTION: ${r.name}
          ${r.data}
        '';
        mapResult = r: (concatStringsSep "\n" (map mkSection r));
        vimConfig = nvim.dag.resolveDag {
          name = "vim config script";
          dag = cfgVim.configRC;
          inherit mapResult;
        };
      in
        vimConfig;

      startPlugins = buildConfigPlugins cfgVim.startPlugins;
      optPlugins = buildConfigPlugins cfgVim.optPlugins;

      package =
        (pkgs.wrapNeovimUnstable cfgBuild.package (neovimConfig
          // {
            wrapRc = true;
          }))
        .overrideAttrs (oldAttrs: {
          passthru =
            oldAttrs
            // {
              extendConfiguration = {
                modules ? [],
                pkgs ? config._module.args.pkgs,
                lib ? pkgs.lib,
                extraSpecialArgs ? {},
                check ? config._module.args.check,
              }:
                import ../../modules {
                  modules = currentModules ++ modules;
                  extraSpecialArgs = config._module.specialArgs // extraSpecialArgs;
                  inherit pkgs lib;
                };
            };
          meta =
            oldAttrs.meta
            // {
              module = {
                inherit config options;
              };
            };
        });
    };
  };
}
