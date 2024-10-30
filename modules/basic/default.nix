{
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
in {
  options.vim = {
    colourTerm = mkOption {
      type = types.bool;
      default = true;
      description = "Set terminal up for 256 colours";
    };

    transparentBackground = mkOption {
      type = types.bool;
      default = false;
      description = "Set the background to transparent";
    };

    disableArrows = mkOption {
      type = types.bool;
      default = true;
      description = "Set to prevent arrow keys from moving cursor";
    };

    hideSearchHighlight = mkOption {
      type = types.bool;
      default = false;
      description = "Hide search highlight so it doesn't stay highlighted";
    };

    scrollOffset = mkOption {
      type = types.int;
      default = 8;
      description = "Start scrolling this number of lines from the top or bottom of the page.";
    };

    wordWrap = mkOption {
      type = types.bool;
      default = true;
      description = "Enable word wrapping.";
    };

    syntaxHighlighting = mkOption {
      type = types.bool;
      default = true;
      description = "Enable syntax highlighting";
    };

    mapLeaderSpace = mkOption {
      type = types.bool;
      default = true;
      description = "Map the space key to leader key";
    };

    useSystemClipboard = mkOption {
      type = types.bool;
      default = true;
      description = "Make use of the clipboard for default yank and paste operations. Don't use * and +";
    };

    mouseSupport = mkOption {
      type = with types; enum ["a" "n" "v" "i" "c"];
      default = "a";
      description = "Set modes for mouse support. a - all, n - normal, v - visual, i - insert, c - command";
    };

    lineNumberMode = mkOption {
      type = with types; enum ["relative" "number" "relNumber" "none"];
      default = "relNumber";
      description = "How line numbers are displayed. none, relative, number, relNumber";
    };

    preventJunkFiles = mkOption {
      type = types.bool;
      default = false;
      description = "Prevent swapfile, backupfile from being created";
    };

    tabWidth = mkOption {
      type = types.int;
      default = 4;
      description = "Set the width of tabs";
    };

    autoIndent = mkOption {
      type = types.bool;
      default = true;
      description = "Enable auto indent";
    };

    cmdHeight = mkOption {
      type = types.int;
      default = 1;
      description = "Height of the command pane";
    };

    updateTime = mkOption {
      type = types.int;
      default = 300;
      description = "The number of milliseconds till Cursor Hold event is fired";
    };

    showSignColumn = mkOption {
      type = types.bool;
      default = true;
      description = "Show the sign column";
    };

    bell = mkOption {
      type = types.enum ["none" "visual" "on"];
      default = "none";
      description = "Set how bells are handled. Options: on, visual or none";
    };

    mapTimeout = mkOption {
      type = types.int;
      default = 500;
      description = "Timeout in ms that neovim will wait for mapped action to complete";
    };

    splitBelow = mkOption {
      type = types.bool;
      default = true;
      description = "New splits will open below instead of on top";
    };

    splitRight = mkOption {
      type = types.bool;
      default = true;
      description = "New splits will open to the right";
    };

    hideStatusLine = mkOption {
      type = types.bool;
      default = false;
      description = "Hide the status line";
    };

    linkStatusLine = mkOption {
      type = types.bool;
      default = false;
      description = "Link StatusLine and StatusLineNC to Normal";
    };

    customStatusLine = mkOption {
      type = types.bool;
      default = false;
      description = "Set custom status line with repeated '─' character";
    };

    list = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the display of whitespace characters";
    };

    keys = {
      coreKeys = mkOption {
        default = true;
        description = "Setup core keybindings";
        type = types.bool;
      };
    };

    bufOnlyCommand = mkOption {
      type = types.bool;
      default = true;
      description = "Define the BufOnly command";
    };
  };

  config = {
    vim.startPlugins = [
      "plenary-nvim"
      "nvim-nio"
      "nui"
    ];

    vim.nmap = mkIf cfg.disableArrows {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    };

    vim.imap = mkIf cfg.disableArrows {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    };

    vim.nnoremap = mkMerge [
      (mkIf cfg.mapLeaderSpace {"<space>" = "<nop>";})
      (mkIf cfg.keys.coreKeys {
        "<C-h>" = "<C-w>h";
        "<C-j>" = "<C-w>j";
        "<C-k>" = "<C-w>k";
        "<C-l>" = "<C-w>l";

        "<A-Up>" = ":resize -3<CR>";
        "<A-Down>" = ":resize +3<CR>";
        "<A-Left>" = ":vertical resize -3<CR>";
        "<A-Right>" = ":vertical resize +3<CR>";

        "<F4>" = ":setlocal spell<CR>";

        # Return to last edit buffer.
        "<S-Tab>" = ":e #<CR>";

        # Move and center
        "<C-d>" = "<C-d>zz";
        "<C-u>" = "<C-u>zz";

        # Search and replace
        "<leader>sr" = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";

        # Clear Search
        "<leader>dv" = ":noh<CR>";

        # BufOnly command
        "<leader>bq" = ":BufOnly<CR>";
      })
    ];

    vim.vnoremap = mkIf cfg.keys.coreKeys {
      # Move line up and down
      "J" = ":m '>+1<CR>gv=gv";
      "K" = ":m '<-2<CR>gv=gv";
    };

    vim.configRC.basic = nvim.dag.entryAfter ["globalsScript"] ''
      " Settings that are set for everything
      set encoding=utf-8
      set mouse=${cfg.mouseSupport}
      set tabstop=${toString cfg.tabWidth}
      set shiftwidth=${toString cfg.tabWidth}
      set softtabstop=${toString cfg.tabWidth}
      set expandtab
      set cmdheight=${toString cfg.cmdHeight}
      set updatetime=${toString cfg.updateTime}
      set shortmess+=c
      set tm=${toString cfg.mapTimeout}
      set hidden
      ${optionalString cfg.splitBelow ''
        set splitbelow
      ''}
      ${optionalString cfg.splitRight ''
        set splitright
      ''}
      ${optionalString cfg.showSignColumn ''
        set signcolumn=yes
      ''}
      ${optionalString cfg.autoIndent ''
        set autoindent
      ''}

      ${optionalString cfg.preventJunkFiles ''
        set noswapfile
        set nobackup
        set nowritebackup
      ''}
      ${optionalString (cfg.bell == "none") ''
        set noerrorbells
        set novisualbell
      ''}
      ${optionalString (cfg.bell == "on") ''
        set novisualbell
      ''}
      ${optionalString (cfg.bell == "visual") ''
        set noerrorbells
      ''}
      ${optionalString (cfg.lineNumberMode == "relative") ''
        set relativenumber
      ''}
      ${optionalString (cfg.lineNumberMode == "number") ''
        set number
      ''}
      ${optionalString (cfg.lineNumberMode == "relNumber") ''
        set number relativenumber
      ''}
      ${optionalString cfg.useSystemClipboard ''
        set clipboard+=unnamedplus
      ''}
      ${optionalString cfg.mapLeaderSpace ''
        let mapleader=" "
        let maplocalleader=" "
      ''}
      ${optionalString cfg.syntaxHighlighting ''
        syntax on
      ''}
      ${optionalString (!cfg.wordWrap) ''
        set nowrap
      ''}
      ${optionalString cfg.hideSearchHighlight ''
        set nohlsearch
        set incsearch
      ''}
      ${optionalString cfg.colourTerm ''
        set termguicolors
        set t_Co=256
      ''}
      ${optionalString cfg.transparentBackground ''
        hi Normal guibg=NONE ctermbg=NONE
      ''}
      ${optionalString cfg.hideStatusLine ''
        set laststatus=0
      ''}
      ${optionalString cfg.linkStatusLine ''
        hi! link StatusLine Normal
        hi! link StatusLineNC Normal
      ''}
      ${optionalString cfg.customStatusLine ''
        set statusline=%{repeat('─',winwidth('.'))}
      ''}
      ${optionalString cfg.list ''
        set list
      ''}
      ${optionalString cfg.bufOnlyCommand ''
        command! BufOnly silent! execute "%bd|e#|bd#"
      ''}
    '';
  };
}
