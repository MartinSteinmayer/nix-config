{ pkgs, ... }:

{
  programs.nvf.settings.vim.lazy.plugins."sidekick.nvim" = {
    package = pkgs.vimPlugins."sidekick-nvim";
    keys = [
      {
        key = "<C-,>";
        mode = [
          "n"
          "t"
          "i"
          "x"
        ];
        action = ''function() require("sidekick.cli").toggle() end'';
        lua = true;
        desc = "Sidekick Toggle";
      }
      {
        key = "<leader>aa";
        mode = "n";
        action = ''function() require("sidekick.cli").toggle() end'';
        lua = true;
        desc = "Sidekick Toggle CLI";
      }
      {
        key = "<leader>as";
        mode = "n";
        action = ''function() require("sidekick.cli").select() end'';
        lua = true;
        desc = "Select CLI";
      }
      {
        key = "<leader>ad";
        mode = "n";
        action = ''function() require("sidekick.cli").close() end'';
        lua = true;
        desc = "Detach a CLI Session";
      }
      {
        key = "<leader>at";
        mode = [
          "x"
          "n"
        ];
        action = ''function() require("sidekick.cli").send({ msg = "{this}" }) end'';
        lua = true;
        desc = "Send This";
      }
      {
        key = "<leader>ab";
        mode = "n";
        action = ''function() require("sidekick.cli").send({ msg = "{file}" }) end'';
        lua = true;
        desc = "Send File";
      }
      {
        key = "<leader>av";
        mode = [ "x" ];
        action = ''function() require("sidekick.cli").send({ msg = "{selection}" }) end'';
        lua = true;
        desc = "Send Visual Selection";
      }
      {
        key = "<leader>ap";
        mode = [
          "n"
          "x"
        ];
        action = ''function() require("sidekick.cli").prompt() end'';
        lua = true;
        desc = "Sidekick Select Prompt";
      }
      {
        key = "<leader>ac";
        mode = "n";
        action = ''function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end'';
        lua = true;
        desc = "Sidekick Toggle Claude";
      }
    ];
    after = ''
      require("sidekick").setup({
        cli = {
          mux = {
            backend = "zellij",
            enabled = true,
          },
        },
        keymap = {
          ["<Tab>"] = {
            "snippet_forward",
            function()
              return require("sidekick").nes_jump_or_apply()
            end,
            function()
              return vim.lsp.inline_completion.get()
            end,
            "fallback",
          },
        },
      })
    '';
  };
}
