{ ... }:

{
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {
      globals = {
        mapleader = " ";
      };

      options = {
        number = true;
        relativenumber = false;
        clipboard = "unnamedplus";
        syntax = "on";
        autoindent = true;
        cursorline = true;
        ignorecase = true;
        smartcase = true;
        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;
        encoding = "UTF-8";
        ruler = true;
        mouse = "a";
        hidden = true;
        wildmenu = true;
        showmatch = true;
        splitright = true;
        splitbelow = true;
        termguicolors = true;
        guicursor = "n:block-blinkwait700-blinkon400-blinkoff250,i:block-blinkon0";
        wrap = false;
      };

      viAlias = true;
      vimAlias = true;

      theme = {
        enable = true;
        name = "rose-pine";
        style = "moon";
        transparent = true;
      };

      luaConfigRC = {
        lspServers = ''
          vim.lsp.config("eslint", {
            root_dir = function(fname)
              local util = require("lspconfig.util")
              return util.root_pattern("pnpm-workspace.yaml", "lerna.json", ".git")(fname)
            end,
          })
          vim.lsp.enable("eslint")

          vim.lsp.config("tailwindcss", {})
          vim.lsp.enable("tailwindcss")

          vim.lsp.config("copilot", {})
          vim.lsp.enable("copilot")
        '';

        customCommands = ''
          vim.api.nvim_create_user_command("Cppath", function()
            local path = vim.fn.expand("%:p")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
          end, {})

          vim.api.nvim_create_user_command("MdOpen", function()
            local input = vim.fn.expand("%:p")
            local base = vim.fn.expand("%:t:r")

            local outdir = vim.fn.expand("~/Documents/md-preview")
            vim.fn.mkdir(outdir, "p")

            local out = outdir .. "/" .. base .. ".html"

            vim.fn.system({ "pandoc", input, "-s", "-o", out })
            vim.fn.jobstart({ "xdg-open", out }, { detach = true })
          end, {})
        '';
      };

      lsp.servers.lua-language-server.settings = {
        Lua = {
          diagnostics.globals = [ "vim" ];
          workspace.checkThirdParty = false;
        };
      };

    };
  };
}
