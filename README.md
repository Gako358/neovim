# My personal neovim config for Nix

Welcome to my Neovim configuration crafted for Nix.
Feel free to use it as is or extract pieces to help construct your own unique setup.

![screenshot](https://github.com/Gako358/archive/blob/main/images/config/neovim.png)

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

**Formatting**: [cabal-fmt](https://github.com/phadej/cabal-fmt)

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

**LSP Server**: [metals](https://github.com/scalameta/nvim-metals)

### Typescript

**LSP Server**: [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)

**Linting**

Using [eslint](https://github.com/prettier/prettier) through null-ls.

**Formatting**

Disabled lsp server formatting, using [prettier](https://github.com/prettier/prettier) through null-ls.

## Plugins

### LSP Plugins

- **[fidget.nvim](https://github.com/j-hui/fidget.nvim)**: Standalone UI for nvim-lsp progress.
- **[nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb)**: VSCode-like code actions.
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: Quickstart configurations for the Nvim LSP client.
- **[lspkind-nvim](https://github.com/onsails/lspkind-nvim)**: VSCode-like pictograms for neovim lsp completion items.
- **[null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)**: Use Neovim as a language server to inject LSP diagnostics, code actions, and more.
- **[lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim)**: LSP signature hint as you type.
- **[trouble.nvim](https://github.com/folke/trouble.nvim)**: A pretty diagnostics, references, telescope results, quickfix and location list.

### LSP Tools

- **[crates.nvim](https://github.com/Saecki/crates.nvim)**: Rust dependency management.
- **[nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)**: Java LSP support.
- **[nvim-metals](https://github.com/scalameta/nvim-metals)**: Scala LSP support.
- **[rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)**: Tools for better development in Rust using Neovim's builtin LSP.
- **[sqls.nvim](https://github.com/nanotee/sqls.nvim)**: SQL language server support.

### Debugging

- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)**: Debug Adapter Protocol client implementation for Neovim.
- **[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)**: A UI for nvim-dap.
- **[nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text)**: Virtual text support for nvim-dap.
- **[nvim-nio](https://github.com/nvim-neotest/nvim-nio)**: Neovim IO library.

### Telescope

- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: Highly extendable fuzzy finder over lists.

### Autocompletion

- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: A completion plugin for neovim coded in Lua.
- **[cmp-buffer](https://github.com/hrsh7th/cmp-buffer)**: nvim-cmp source for buffer words.
- **[cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)**: nvim-cmp source for neovim's built-in LSP.
- **[cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip)**: nvim-cmp source for vim-vsnip.
- **[cmp-path](https://github.com/hrsh7th/cmp-path)**: nvim-cmp source for filesystem paths.
- **[cmp-treesitter](https://github.com/ray-x/cmp-treesitter)**: nvim-cmp source for treesitter.
- **[cmp-dap](https://github.com/rcarriga/cmp-dap)**: nvim-cmp source for nvim-dap.

### Snippets

- **[vim-vsnip](https://github.com/hrsh7th/vim-vsnip)**: Snippet plugin for vim/nvim that supports LSP/VSCode's snippet format.

### Copilot

- **[copilot.lua](https://github.com/zbirenbaum/copilot.lua)**: Lua plugin for GitHub Copilot.
- **[CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim)**: Chat interface for GitHub Copilot.

### Markdown

- **[glow.nvim](https://github.com/ellisonleao/glow.nvim)**: Markdown preview using glow.

### Git

- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: Git integration for buffers.
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)**: Plugin for calling lazygit from within neovim.
- **[undotree](https://github.com/jiaoshijie/undotree)**: Undo tree visualizer for Neovim.

### Visuals

- **[rose-pine](https://github.com/rose-pine/neovim)**: All natural pine, faux fur and a bit of soho vibes for the classy minimalist.
- **[lualine.nvim](https://github.com/hoob3rt/lualine.nvim)**: A blazing fast and easy to configure neovim statusline plugin.
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)**: A super powerful autopair plugin for Neovim.
- **[indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)**: Indent guides for Neovim.
- **[nvim-cursorline](https://github.com/yamatsum/nvim-cursorline)**: Highlight the current line and word under the cursor.
- **[nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)**: Lua fork of vim-web-devicons for neovim.
- **[noice.nvim](https://github.com/folke/noice.nvim)**: Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
- **[nui.nvim](https://github.com/MunifTanjim/nui.nvim)**: UI Component Library for Neovim.
- **[nvim-notify](https://github.com/rcarriga/nvim-notify)**: A fancy, configurable, notification manager for NeoVim.
- **[ranger.nvim](https://github.com/kelly-lin/ranger.nvim)**: Ranger integration for Neovim.

### Key Binding Help

- **[which-key.nvim](https://github.com/folke/which-key.nvim)**: Neovim plugin that shows a popup with possible keybindings of the command you started typing.

### Utility

- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)**: All the lua functions you don't want to write twice.

# License

> The files and scripts in this repository are licensed under the MIT License, which is a very
> permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software.
> In other words, do what you want with it. The only requirement with the MIT License is that the license
> and copyright notice must be provided with the software.
