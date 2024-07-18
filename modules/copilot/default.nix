{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.copilot.chat;
in {
  options.vim.copilot.chat = {
    enable = mkEnableOption "chat";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [
      "copilot"
      "copilot-chat"
    ];

    vim.luaConfigRC.chat =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require("copilot").setup({
          suggestion = {
            keymap = {
              accept = "<C-j>",
              next = "<M-n>",
            },
          },
        })


        require("CopilotChat").setup({
          model = "gpt-4",
          context = "buffers",
          window = {
            layout = "float",
            width = 0.7,
            height = 0.9,
            title = "Copilot Chat",
          },
        })

        vim.keymap.set({ 'n', 'v' }, '<leader>cc', '<cmd>CopilotChatToggle<cr>', { desc = "CopilotChat - Toggle" })
        vim.keymap.set({ 'n', 'v' }, '<leader>cce', '<cmd>CopilotChatExplain<cr>', { desc = "CopilotChat - Explain code" })
        vim.keymap.set({ 'n', 'v' }, '<leader>cct', '<cmd>CopilotChatTests<cr>', { desc = "CopilotChat - Generate tests" })
        vim.keymap.set({ 'n', 'v' }, '<leader>ccf', '<cmd>CopilotChatFixDiagnostic<cr>', { desc = "CopilotChat - Fix diagnostic" })
        vim.keymap.set({ 'n', 'v' }, '<leader>ccr', '<cmd>CopilotChatReset<cr>', { desc = "CopilotChat - Reset chat history and clear buffer" })
        vim.keymap.set({ 'n', 'v' }, '<leader>cco', '<cmd>CopilotChatOptimize<cr>', { desc = "CopilotChat - Optimize selected code" })
        vim.keymap.set({ 'n', 'v' }, '<leader>ccd', '<cmd>CopilotChatDocs<cr>', { desc = "CopilotChat - Add docs on selected code" })
        vim.keymap.set({ 'n', 'v' }, '<leader>ccp', '<cmd>CopilotChatReview<cr>', { desc = "CopilotChat - Review selected code" })
        vim.keymap.set('n', '<leader>ccp', function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end, { desc = 'CopilotChat - Prompt actions' })
        vim.keymap.set("n", "<leader>ccq", function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end, { desc = 'CopilotChat - Quick chat' })
      '';
  };
}
