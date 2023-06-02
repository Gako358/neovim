{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.chatgpt;
in {
  options.vim.chatgpt = {
    enable = mkOption {
      type = types.bool;
      description = "Enable ChatGPT.nvim plugin";
    };
    openaiApiKey = mkOption {
      default = null;
      description = "The OpenAI API KEY (can also be set as an env variable)";
      type = types.nullOr types.str;
    };
    model = mkOption {
      default = "gpt-3.5-turbo";
      description = "The model to use";
      type = types.str;
    };
    frequencyPenalty = mkOption {
      default = 0;
      description = "The frequency penalty to use";
      type = types.int;
    };
    temperature = mkOption {
      default = 0;
      description = "The temperature to use";
      type = types.int;
    };
    presencePenalty = mkOption {
      default = 0;
      description = "The presence penalty to use";
      type = types.int;
    };
    maxTokens = mkOption {
      default = 2000;
      description = "The max tokens to use";
      type = types.int;
    };
    topP = mkOption {
      default = 1;
      description = "The top P to use";
      type = types.int;
    };
    n = mkOption {
      default = 1;
      description = "The n to use";
      type = types.int;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-chatgpt"];

    vim.luaConfigRC.chatgpt = nvim.dag.entryAnywhere ''
      require("chatgpt").setup({
        openai_params = {
          model = "${cfg.model}";
          frequency_penalty = ${toString cfg.frequencyPenalty};
          temperature = ${toString cfg.temperature};
          presence_penalty = ${toString cfg.presencePenalty};
          max_tokens = ${toString cfg.maxTokens};
          top_p = ${toString cfg.topP};
          n = ${toString cfg.n};
        },
        ${
        if cfg.openaiApiKey != null
        then ''openai_api_key = "${cfg.openaiApiKey}"''
        else ""
      }
      })

      local chatgpt = require("chatgpt")
      vim.keymap.set('n', '<leader>co', function() chatgpt.openChat() end, {remap=true})
      vim.keymap.set({'n', 'i'}, '<C-g>', function() chatgpt.complete_code() end, {remap=true})
      vim.keymap.set('v', '<leader>cr', function() chatgpt.run_actions() end, {remap=true})
      vim.keymap.set("v", "<leader>ci", function() chatgpt.edit_with_instructions() end, {remap=true})
    '';
  };
}
