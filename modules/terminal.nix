{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.terminal;
in {
  options.vim.terminal = {
    enable = mkEnableOption "Custom terminals";
    default = true;
    simple.enable = mkEnableOption "Enable simple terminal";
    float.enable = mkEnableOption "Enable floating terminal";
    project.enable = mkEnableOption "Enable project terminal";
    new_tab.enable = mkEnableOption "Enable new tab terminal";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.simple.enable {
      vim.luaConfigRC.gui =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          local state = {
            simple = {
              buf = -1,
              win = -1,
            }
          }

          local function create_simple_terminal()
            -- Create a new buffer if it doesn't exist
            if not vim.api.nvim_buf_is_valid(state.simple.buf) then
              state.simple.buf = vim.api.nvim_create_buf(false, true)
            end

            -- Create a new window
            vim.cmd("vnew")
            vim.cmd.wincmd("J")
            vim.api.nvim_win_set_height(0, 19)
            vim.api.nvim_win_set_buf(0, state.simple.buf)
            state.simple.win = vim.api.nvim_get_current_win()
          end

          local function toggle_simple_terminal()
            if not vim.api.nvim_win_is_valid(state.simple.win) then
              create_simple_terminal()
              if vim.bo[state.simple.buf].buftype ~= "terminal" then
                vim.cmd.term()
              end
            else
              vim.api.nvim_win_hide(state.simple.win)
            end
          end

          -- Which-key mappings if enabled
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>t", group = "Terminal" },
              { "<leader>tv", "<cmd>vsplit | terminal<CR>", desc = "Open vertical split terminal" },
              { "<leader>ts", toggle_simple_terminal, desc = "Toggle simple terminal below" },
              { "<ESC><ESC>", "<C-\\><C-n>", desc = "Exit terminal mode", mode = "t" },
            })
          else
            -- Regular mappings if which-key is disabled
            vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", {desc = "Exit terminal mode"})
            vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", {desc = "Open vertical split terminal"})
            vim.keymap.set({"n", "t"}, "<leader>ts", toggle_simple_terminal, {desc = "Toggle simple terminal below"})
          end
        '';
    })

    (mkIf cfg.float.enable {
      vim.luaConfigRC.gui =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          local state = {
            floating = {
              buf = -1,
              win = -1,
            }
          }

          local function create_floating_window(opts)
            opts = opts or {}
            local width = math.floor(vim.o.columns * 0.8)
            local height = math.floor(vim.o.lines * 0.8)
            local row = math.floor((vim.o.lines - height) / 2)
            local col = math.floor((vim.o.columns - width) / 2)
            local win_opts = {
              style = "minimal",
              relative = "editor",
              width = width,
              height = height,
              row = row,
              col = col,
            }
            if opts.buf == -1 or not vim.api.nvim_buf_is_valid(opts.buf) then
              opts.buf = vim.api.nvim_create_buf(false, true)
              state.floating.buf = opts.buf
            end
            return vim.api.nvim_open_win(opts.buf, true, win_opts)
          end

          -- Toggle terminal
          local toggle_terminal = function()
            if not vim.api.nvim_win_is_valid(state.floating.win) then
              state.floating.win = create_floating_window { buf = state.floating.buf }
              if vim.bo[state.floating.buf].buftype ~= "terminal" then
                vim.cmd.term()
              end
            else
              vim.api.nvim_win_hide(state.floating.win)
            end
          end

          -- Which-key mappings if enabled
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>t", group = "Terminal" },
              { "<leader>tf", toggle_terminal, desc = "Toggle floating terminal", mode = { "n", "t" } },
            })
          else
            -- Regular mappings if which-key is disabled
            vim.keymap.set({"n", "t"}, "<leader>tf", toggle_terminal, {desc = "Toggle floating terminal"})
          end
        '';
    })

    (mkIf cfg.project.enable {
      vim.luaConfigRC.gui =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          function _G.OpenProjectTerminal()
            vim.cmd("tabnew")
            vim.cmd("terminal")
            vim.cmd("vsplit")
            vim.cmd("terminal")
            vim.cmd("split")
            vim.cmd("terminal")
          end

          -- Which-key mappings if enabled
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>t", group = "Terminal" },
              { "<leader>tp", "<cmd>lua OpenProjectTerminal()<CR>", desc = "Open new tab with project terminals" },
            })
          else
            -- Regular mappings if which-key is disabled
            vim.keymap.set("n", "<leader>tp", ":lua OpenProjectTerminal()<CR>", {desc = "Open new tab with project terminals"})
          end
        '';
    })

    (mkIf cfg.project.enable {
      vim.luaConfigRC.gui =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          function _G.OpenGitTerminal()
            vim.cmd("tabnew")
            vim.cmd("terminal")
          end

          -- Which-key mappings if enabled
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>t", group = "Terminal" },
              { "<leader>tg", "<cmd>lua OpenGitTerminal()<CR>", desc = "Open new tab with git terminal" },
            })
          else
            -- Regular mappings if which-key is disabled
            vim.keymap.set("n", "<leader>tg", ":lua OpenGitTerminal()<CR>", {desc = "Open new tab with git terminals"})
          end
        '';
    })

    (mkIf cfg.new_tab.enable {
      vim.luaConfigRC.gui =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          function _G.OpenNewTabTerminal()
            vim.cmd("tabnew")
            vim.cmd("terminal")
          end

          -- Which-key mappings if enabled
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>t", group = "Terminal" },
              { "<leader>tn", "<cmd>lua OpenNewTabTerminal()<CR>", desc = "Open new tab terminal" },
            })
          else
            -- Regular mapping if which-key is disabled
            vim.keymap.set("n", "<leader>tn", ":lua OpenNewTabTerminal()<CR>", {desc = "Open new tab terminal"})
          end
        '';
    })
    (mkIf true {
      vim.luaConfigRC.gui =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>t", group = "Terminal" },
              { "<leader>tc", "<cmd>tabclose<CR>", desc = "Close current tab" },
            })
          else
            vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", {desc = "Close current tab"})
          end
        '';
    })
  ]);
}
