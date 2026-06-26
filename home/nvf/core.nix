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
        shiftwidth = 2;
        tabstop = 2;
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

          _G.copy_with_file_and_lines = function(kind)
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.bo[buf].filetype
            local source_filetypes = {
              bash = true,
              c = true,
              cpp = true,
              css = true,
              go = true,
              html = true,
              java = true,
              javascript = true,
              javascriptreact = true,
              json = true,
              lua = true,
              nix = true,
              plaintex = true,
              python = true,
              rust = true,
              sh = true,
              tex = true,
              toml = true,
              typescript = true,
              typescriptreact = true,
              yaml = true,
              zsh = true,
            }

            if not source_filetypes[ft] then
              vim.notify("Not a configured source filetype", vim.log.levels.WARN)
              return
            end

            local file = vim.api.nvim_buf_get_name(buf)
            if file == "" then
              vim.notify("Buffer has no file path", vim.log.levels.WARN)
              return
            end

            local start_line, start_col, end_line, end_col

            if kind == "visual" then
              local start_pos = vim.fn.getpos("'<")
              local end_pos = vim.fn.getpos("'>")
              start_line, start_col = start_pos[2], start_pos[3]
              end_line, end_col = end_pos[2], end_pos[3]

              if start_line > end_line or (start_line == end_line and start_col > end_col) then
                start_line, end_line = end_line, start_line
                start_col, end_col = end_col, start_col
              end
            else
              start_line = vim.api.nvim_win_get_cursor(0)[1]
              end_line = start_line
              start_col = 1
              end_col = #vim.api.nvim_buf_get_lines(buf, start_line - 1, start_line, false)[1]
            end

            local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
            if #lines == 0 then
              return
            end

            if kind == "visual" then
              lines[1] = string.sub(lines[1], start_col)
              lines[#lines] = string.sub(lines[#lines], 1, end_col)
            end

            local text = table.concat(lines, "\n")
            local relative_file = vim.fn.fnamemodify(file, ":.")
            local payload = string.format("%s(%d-%d): %s", relative_file, start_line, end_line, text)

            if vim.fn.executable("wl-copy") ~= 1 then
              vim.notify("wl-copy is not available", vim.log.levels.ERROR)
              return
            end

            local job = vim.fn.jobstart({ "wl-copy" }, { stdin = "pipe" })
            if job <= 0 then
              vim.notify("Failed to start wl-copy", vim.log.levels.ERROR)
              return
            end

            vim.fn.chansend(job, payload)
            vim.fn.chanclose(job, "stdin")
            vim.notify("Copied code with file and line range", vim.log.levels.INFO)
          end
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
