{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.gui;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "project"
      "session"
    ];

    vim.luaConfigRC.gui =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        vim.api.nvim_set_keymap('n', '<leader>pp', '<cmd>NeovimProjectDiscover<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>pr', '<cmd>NeovimProjectLoadRecent<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>ph', '<cmd>NeovimProjectHistory<CR>', { noremap = true, silent = true })

        require("neovim-project").setup {
          projects = {
            "~/Projects/*",
            "~/Projects/plugins/*",
            "~/Projects/workspace/*",
            "~/Sources/*",
            "~/Documents/*",
          },
          picker = {
            type = "telescope",
          }
        }
        require("session_manager").setup{}

        local function setup_direnv()
          local Direnv = {}

          local function check_executable(executable_name)
            if (vim.fn.executable(executable_name) == 1) then
              return true
            else
              vim.notify(("Executable '" .. executable_name .. "' not found"), vim.log.levels.ERROR)
              return false
            end
          end

          local function setup_keymaps(keymaps, mode)
            for _, map in ipairs(keymaps) do
              local options = vim.tbl_extend("force", {noremap = true, silent = true}, (map[3] or {}))
              vim.keymap.set(mode, map[1], map[2], options)
            end
            return nil
          end

          Direnv.direnv_allow = function()
            print("Allowing direnv...")
            return os.execute("direnv allow")
          end

          Direnv.direnv_deny = function()
            print("Denying direnv")
            return os.execute("direnv deny")
          end

          Direnv._get_rc_status = function(_on_exit)
            local on_exit
            local function _2_(obj)
              local status = vim.json.decode(obj.stdout)
              if (status.state.foundRC == nil) then
                return _on_exit(nil, nil)
              else
                return _on_exit(status.state.foundRC.allowed, status.state.foundRC.path)
              end
            end
            on_exit = _2_
            return vim.system({"direnv", "status", "--json"}, {text = true, cwd = vim.fn.getcwd(-1, -1)}, on_exit)
          end

          Direnv._init = function(path)
            local function _4_()
              return vim.notify(("Reloading " .. path))
            end
            vim.schedule(_4_)
            local cwd = vim.fs.dirname(path)
            local on_exit
            local function _5_(obj)
              local function _6_()
                local function _7_()
                  local tbl_21_auto = {}
                  local i_22_auto = 0
                  for _, v in ipairs(vim.fn.split(obj.stdout, "call setenv")) do
                    local val_23_auto = ("call setenv" .. v)
                    if (nil ~= val_23_auto) then
                      i_22_auto = (i_22_auto + 1)
                      tbl_21_auto[i_22_auto] = val_23_auto
                    else
                    end
                  end
                  return tbl_21_auto
                end
                return vim.fn.execute(_7_())
              end
              return vim.schedule(_6_)
            end
            on_exit = _5_
            return vim.system({"direnv", "export", "vim"}, {text = true, cwd = cwd}, on_exit)
          end

          Direnv.check_direnv = function()
            vim.notify("running check")
            local on_exit
            local function _9_(status, path)
              if not ((path == nil) or (status == nil)) then
                if (status == 0) then
                  return Direnv._init(path)
                elseif (status == 2) then
                  return nil
                else
                  local _ = status
                  local function _10_()
                    local choice = vim.fn.confirm((path .. " is blocked." .. "&Allow &Block &Ignore" .. 3))
                    if (choice == 1) then
                      Direnv.direnv_allow()
                      return Direnv._init()
                    elseif (choice == 2) then
                      return Direnv._init()
                    else
                      return nil
                    end
                  end
                  return vim.schedule(_10_)
                end
              else
                return nil
              end
            end
            on_exit = _9_
            return Direnv._get_rc_status(on_exit)
          end

          Direnv.setup = function(user_config)
            local config = vim.tbl_deep_extend("force", {bin = "direnv", keybindings = {allow = "<Leader>da", deny = "<Leader>dd", reload = "<Leader>dr"}, autoload_direnv = false}, (user_config or {}))
            if not check_executable(config.bin) then
              return nil
            else
              local function _14_(opts)
                local cmds = {allow = Direnv.direnv_allow, deny = Direnv.direnv_deny, reload = Direnv.check_direnv}
                local cmd = cmds[string.lower(opts.fargs[1])]
                if cmd() then
                  return cmd()
                else
                  return nil
                end
              end
              local function _16_()
                return {"allow", "deny", "reload"}
              end
              vim.api.nvim_create_user_command("Direnv", _14_, {nargs = 1, complete = _16_})
              setup_keymaps({{config.keybindings.allow, Direnv.direnv_allow, {desc = "Allow direnv"}}, {config.keybindings.deny, Direnv.direnv_deny, {desc = "Deny direnv"}}, {config.keybindings.reload, Direnv.check_direnv, {desc = "Reload direnv"}}}, "n")
              local group_id = vim.api.nvim_create_augroup("DirenvNvim", {})
              if (config.autoload_direnv and (vim.fn.glob("**/.envrc") ~= "")) then
                return vim.api.nvim_create_autocmd({"DirChanged"}, {pattern = "*", group = group_id, callback = Direnv.check_direnv})
              else
                return nil
              end
            end
          end

          return Direnv
        end

        local Direnv = setup_direnv()
        Direnv.setup({})
      '';
  };
}
