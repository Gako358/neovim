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

          vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", {desc = "Exit terminal mode"})
          vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", {desc = "Open vertical split terminal"})
          vim.keymap.set({"n", "t"}, "<leader>ts", toggle_simple_terminal, {desc = "Toggle simple terminal below"})
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
            local width = opts.width or math.floor(vim.o.columns * 0.73)
            local height = opts.height or math.floor(vim.o.lines * 0.73)

            -- Calculate the pos to center the window
            local col = math.floor((vim.o.columns - width) / 2)
            local row = math.floor((vim.o.lines - height) / 2)

            -- Create a new buffer
            local buf = nil
            if vim.api.nvim_buf_is_valid(opts.buf) then
              buf = opts.buf
            else
              buf = vim.api.nvim_create_buf(false, true)
            end

            -- Define window config
            local win_config = {
              relative = "editor",
              width = width,
              height = height,
              col = col,
              row = row,
              style = "minimal",
              border = "rounded",
            }

            -- Create the floating window
            local win = vim.api.nvim_open_win(buf, true, win_config)
            return { buf = buf, win = win }
          end

          -- Toggle terminal
          local toggle_terminal = function()
            if not vim.api.nvim_win_is_valid(state.floating.win) then
              state.floating = create_floating_window { buf = state.floating.buf }
              if vim.bo[state.floating.buf].buftype ~= "terminal" then
                vim.cmd.term()
              end
            else
              vim.api.nvim_win_hide(state.floating.win)
            end
          end
          -- Create a floating window
          vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
          vim.keymap.set({"n", "t"}, "<leader>tf", toggle_terminal, {desc = "Toggle floating terminal"})
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

          vim.keymap.set("n", "<leader>tp", ":lua OpenProjectTerminal()<CR>", {desc = "Open new tab with project terminals"})
        '';
    })
  ]);
}
