# My personal neovim config for Nix
This is my personal neovim config. Feel free to take bits of it to build your own or run it yourself.
Is is a build based upon [Will Taylors config](https://github.com/wiltaylor/neovim-flake).

## Screenshot
![screenshot](https://github.com/Gako358/Dotfiles/blob/main/Pictures/Images/vim.png)

# How to use
Clone the repo and run the following from the directory:
```
nix run .#
```
or
```
nix run github:gako358/nvimFlakes#.
```

# How to update plugins
```
nix flake update
```

# Folder structure
```
|-[lib] -- Contains my utility functions
|-[modules] -- Contains modules which are used to configure neovim
|-flake.nix -- Flake file
|-README.md -- This file
```

## Language Support

Most languages use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to set up language server. Additionally some languages also (or exclusively) use [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) to extend capabilities.

### Rust

**LSP Server**: [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

**Formatting**

Rust analyzer provides builtin formatting with [rustfmt](https://github.com/rust-lang/rustfmt)

**Plugins**

- [rust-tools](https://github.com/simrat39/rust-tools.nvim)
- [crates.nvim](https://github.com/Saecki/crates.nvim)

### Nix

**LSP Server**: [rnix-lsp](https://github.com/nix-community/rnix-lsp)

**Formatting**

rnix provides builtin formatting with [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt) but it is disabled and I am instead using null-ls with [alejandra](https://github.com/kamadorueda/alejandra)

### C/C++

**LSP Server**: [ccls](https://github.com/MaskRay/ccls)

### Typescript

**LSP Server**: [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)

**Linting**

Using [eslint](https://github.com/prettier/prettier) through null-ls.

**Formatting**

Disabled lsp server formatting, using [prettier](https://github.com/prettier/prettier) through null-ls.



### Python

**LSP Server**: [pyright](https://github.com/microsoft/pyright)

**Formatting**:

Using [black](https://github.com/psf/black) through null-ls


### HTML

**Plugins**

- [nvim-ts-autotag](https://github.com/ellisonleao/glow.nvim/issues/44) for autoclosing and renaming html tags. Works with html, tsx, vue, svelte, and php

## All Plugins

A list of all plugins that can be enabled

### LSP

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) common configurations for built-in language server
- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) neovim as a language server to inject LSP diagnostics, code actions, etc.
- [trouble.nvim](https://github.com/folke/trouble.nvim) pretty list of lsp data
- [nvim-code-action-menu](https://github.com/weilbith/nvim-code-action-menu) provides a handy pop-up menu for code actions
- [nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb) shows a lightbulb in the sign column whenever a codeAction is available

### Buffers

- [nvim-bufferline-lua](https://github.com/akinsho/bufferline.nvim) a buffer line with tab integration

### Terminal
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) a neovim plugin to persist and toggle multiple terminals during an editing session

### Statuslines

- [lualine.nvim](https://github.com/hoob3rt/lualine.nvim) statusline written in lua.

### Filetrees

- [nvim-tree-lua](https://github.com/kyazdani42/nvim-tree.lua) a file explorer tree written in lua. Using

### Git

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) a variety of git decorations

### Treesitter

- Nix installation of treesitter
- [nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context) a context bar using tree-sitter
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) uses treesitter to autoclose/rename html tags

### Visuals

- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) for indentation guides
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) Plugins and colors for icons. Requires patched font

### Utilities

- [telescope](https://github.com/nvim-telescope/telescope.nvim) an extendable fuzzy finder of lists. Working ripgrep and fd
- [which-key](https://github.com/folke/which-key.nvim) a popup that displays possible keybindings of command being typed

### Completions

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) a completion engine that utilizes sources (replaces nvim-compe)
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) a source for buffer words
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) a source for builtin LSP client
    - [cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip) a source for vim-vsnip autocomplete
    - [cmp-path](https://github.com/hrsh7th/cmp-path) a source for path autocomplete
    - [crates.nvim](https://github.com/Saecki/crates.nvim) autocompletion of rust crate versions in `cargo.toml`

### Snippets

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip) a snippet plugin that supports LSP/VSCode's snippet format

### Autopairs

- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) an autopair plugin for neovim

### Themes

- [onedark](https://github.com/navarasu/onedark.nvim) a dark colorscheme with multiple options

### Dependencies

- [plenary](https://github.com/nvim-lua/plenary.nvim) which is a dependency of some plugins, installed automatically if needed


# License
The files and scripts in this repository are licensed under the MIT License, which is a very 
permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software. 
In other words, do what you want with it. The only requirement with the MIT License is that the license 
and copyright notice must be provided with the software.
