# My personal neovim config for Nix

Welcome to my Neovim configuration crafted for Nix. Feel free to use it as is or extract pieces to help construct your own unique setup.

![screenshot](https://github.com/Gako358/archive/blob/main/images/config/nvim.png)

# Usage

To utilize this configuration, clone the repo and run the following command from the directory:

```
nix run .#
```

or

```
nix run github:gako358/neovim#.
```

## Plugin Updates

```shell
nix flake update
```

```shell
nix flake lock --update-input 'Name-of-input'
```

## Repository Structure

```
|-[modules] -- Contains modules which are used to configure neovim
|-flake.nix -- Flake file
|-README.md -- This file
```

## Language Support

Most languages use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to set up language server. Additionally some languages also (or exclusively) use [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) to extend capabilities.

### C/C++

**LSP Server**: [ccls](https://github.com/MaskRay/ccls)

### HTML

**Plugins**

- [nvim-ts-autotag](https://github.com/ellisonleao/glow.nvim/issues/44) for autoclosing and renaming html tags. Works with html, tsx, vue, svelte, and php

### Dhall

**LSP Server**: [dhall-lsp-server](https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-lsp-server)

### Haskell

**LSP Server**: [haskell-language-server](https://github.com/haskell/haskell-language-server)

**Formatting**: [cabal-fmt](https://github.com/phadej/cabal-fmt}

### Java

** LSP Server**: [jdtls](https://github.com/mfussenegger/nvim-jdtls)

**Formatting**: [java-google-formater](https://github.com/google/google-java-format)

### Nix

**LSP Server**: [rnix-lsp](https://github.com/nix-community/rnix-lsp)

**Formatting**

rnix provides builtin formatting with [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt) but it is disabled and I am instead using null-ls with [alejandra](https://github.com/kamadorueda/alejandra)

### Python

**LSP Server**: [pyright](https://github.com/microsoft/pyright)

**Formatting**:

Using [black](https://github.com/psf/black) through null-ls

### Rust

**LSP Server**: [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

**Formatting**

Rust analyzer provides builtin formatting with [rustfmt](https://github.com/rust-lang/rustfmt)

**Plugins**

- [rust-tools](https://github.com/simrat39/rust-tools.nvim)
- [crates.nvim](https://github.com/Saecki/crates.nvim)

### Scala

**LSP Server**: [metals](https://github.com/scalameta/nvim-metals}

### Typescript

**LSP Server**: [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)

**Linting**

Using [eslint](https://github.com/prettier/prettier) through null-ls.

**Formatting**

Disabled lsp server formatting, using [prettier](https://github.com/prettier/prettier) through null-ls.

## Plugins

This configuration includes a variety of plugins designed to enhance your Neovim experience, from LSP and Autopairs, to Completions, Git, Themes, and more. For a complete list and description of all plugins:

### LSP

- [fidget-nvim](https://github.com/j-hui/fidget.nvim) Standalone UI for nvim-lsp progress. Eye candy for the impatient.
- [nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb) shows a lightbulb in the sign column whenever a codeAction is available.
- [lsp-signature](https://github.com/ray-x/lsp_signature.nvim) Show function signature when you type.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) common configurations for built-in language server
- [lspkind-nvim](https://github.com/onsails/lspkind.nvim) This tiny plugin adds vscode-like pictograms to neovim built-in lsp.
- [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) Neovim lsp enhance plugin.
- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) neovim as a language server to inject LSP diagnostics, code actions, etc.
- [nvim-code-action-menu](https://github.com/weilbith/nvim-code-action-menu) provides a handy pop-up menu for code actions
- [trouble.nvim](https://github.com/folke/trouble.nvim) pretty list of lsp data

### Autopairs

- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) an autopair plugin for neovim

### ChatGPT

- [ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim) a plugin for generating text with GPT-3.5 Turbo

### Completions

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) a completion engine that utilizes sources (replaces nvim-compe)
  - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) a source for buffer words
  - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) a source for builtin LSP client
  - [cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip) a source for vim-vsnip autocomplete
  - [cmp-path](https://github.com/hrsh7th/cmp-path) a source for path autocomplete
  - [crates.nvim](https://github.com/Saecki/crates.nvim) autocompletion of rust crate versions in `cargo.toml`

### Filetrees

- [nvim-tree-lua](https://github.com/kyazdani42/nvim-tree.lua) a file explorer tree written in lua. Using

### Git

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) a variety of git decorations

### Snippets

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip) a snippet plugin that supports LSP/VSCode's snippet format

### Statuslines

- [lualine.nvim](https://github.com/hoob3rt/lualine.nvim) statusline written in lua.

### Terminal

- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) a neovim plugin to persist and toggle multiple terminals during an editing session

### Themes

- [borealis](https://github.com/Gako358/borealis.nvim) a dark colorscheme with multiple options

### Treesitter

- Nix installation of treesitter
- [nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context) a context bar using tree-sitter
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) uses treesitter to autoclose/rename html tags

### Utilities

- [telescope](https://github.com/nvim-telescope/telescope.nvim) an extendable fuzzy finder of lists. Working ripgrep and fd
- [which-key](https://github.com/folke/which-key.nvim) a popup that displays possible keybindings of command being typed

### Visuals

- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) for indentation guides
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) Plugins and colors for icons. Requires patched font

## Dependencies

- [plenary](https://github.com/nvim-lua/plenary.nvim) which is a dependency of some plugins, installed automatically if needed

# License

> The files and scripts in this repository are licensed under the MIT License, which is a very
> permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software.
> In other words, do what you want with it. The only requirement with the MIT License is that the license
> and copyright notice must be provided with the software.
