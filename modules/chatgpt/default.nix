{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.chatgpt;
in {
  options.vim.chatgpt = {
    enable = mkOption {
      type = types.bool;
      description = "enable chatGPT plugin: [nvim-editorconfig]";
    };

    windowBorder = mkOption {
      type = types.str;
      default = "rounded";
      description = "window border to use";
    };

    windowText = mkOption {
      type = types.str;
      default = "MerrinX";
      description = "window text to use";
    };

    popupInput = mkOption {
      type = types.str;
      default = "rounded";
      description = "popup input to use";
    };

    popupSubmit = mkOption {
      type = types.str;
      default = "<C-r>";
      description = "popup input to use";
    };

    model = mkOption {
      type = types.str;
      default = "gpt-3.5-turbo";
      description = "model to use";
    };

    temperature = mkOption {
      type = types.int;
      default = 0;
      description = "temperature to use";
    };

    maxTokens = mkOption {
      type = types.int;
      default = 300;
      description = "max tokens to use";
    };

    apiKey = mkOption {
      type = types.str;
      default = "gpg --decrypt ./.apikey.txt.gpg 2>/dev/null";
      description = "openai api key";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["chatgpt"];

    vim.nnoremap = {
      "<leader>pn" = ":ChatGPT<CR>";
      "<leader>pta" = ":ChatGPTActAs<CR>";
      "<leader>ptc" = ":ChatGPTCompleteCode<CR>";
    };

    vim.vnoremap = {
      "<leader>pn" = ":ChatGPTEditWithInstructions<CR>";
    };

    vim.luaConfigRC.chatgpt = nvim.dag.entryAnywhere ''
      require("chatgpt").setup ({
        popup_window = {
          border = {
            style = "${cfg.windowBorder}",
            text = {
              top = "${cfg.windowText}",
            },
          },
        },
        popup_input = {
          border = {
            style = "${cfg.popupInput}",
          },
          submit = "${cfg.popupSubmit}",
        },
        openai_params = {
          model = "${cfg.model}",
          temperature = ${toString cfg.temperature},
          max_tokens = ${toString cfg.maxTokens},
        },
      })
    '';
  };
}
