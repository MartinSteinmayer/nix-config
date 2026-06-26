{ ... }:

{
  programs.nvf.settings.vim.keymaps = [
    {
      key = "jk";
      mode = "i";
      action = "<Esc>";
      desc = "Exit insert mode";
    }
    {
      key = "<leader>ch";
      mode = "n";
      action = ":e ~/.config/nvim/nvim-cheatsheet.md<CR>";
      desc = "Open Neovim cheatsheet";
    }
    {
      key = "<C-t>";
      mode = "t";
      action = "<C-\\><C-n>";
      desc = "Exit terminal mode";
    }
    {
      key = "<leader>ww";
      mode = [
        "n"
        "t"
      ];
      lua = true;
      action = ''
        function()
          vim.wo.wrap = not vim.wo.wrap
        end
      '';
      desc = "Toggle word wrap locally";
    }
    {
      key = "<leader>ff";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.files() end";
      desc = "Find files";
    }
    {
      key = "<leader>fr";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.recent() end";
      desc = "Find recent files";
    }
    {
      key = "<leader>fb";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.buffers() end";
      desc = "Find buffers";
    }
    {
      key = "<leader>fg";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.grep() end";
      desc = "Live grep";
    }
    {
      key = "<leader>fw";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.grep_word() end";
      desc = "Search word under cursor";
    }
    {
      key = "<leader>:";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.command_history() end";
      desc = "Command history";
    }
    {
      key = "<leader>fs";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.git_status() end";
      desc = "Git status";
    }
    {
      key = "<leader>fc";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.git_log() end";
      desc = "Git commits";
    }
    {
      key = "<leader>fd";
      mode = "n";
      lua = true;
      action = ''
        function()
          local has_nvim_tree, api = pcall(require, "nvim-tree.api")
          if not has_nvim_tree then
            vim.notify("nvim-tree is not available", vim.log.levels.ERROR)
            return
          end

          Snacks.picker.pick({
            title = "Directories",
            finder = "proc",
            cmd = "fd",
            args = { "--type", "d", "--hidden", "--exclude", ".git" },
            format = function(item)
              return { { item.text, "Directory" } }
            end,
            preview = false,
            confirm = function(picker, item)
              picker:close()
              if item then
                api.tree.open()
                api.tree.find_file(vim.fn.getcwd() .. "/" .. item.text)
              end
            end,
          })
        end
      '';
      desc = "Find directory and focus in tree";
    }
    {
      key = "<leader>fh";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.help() end";
      desc = "Help tags";
    }
    {
      key = "<leader>fk";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.keymaps() end";
      desc = "Keymaps";
    }
    {
      key = "<leader>fm";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.marks() end";
      desc = "Marks";
    }
    {
      key = "<leader>f:";
      mode = "n";
      lua = true;
      action = "function() Snacks.picker.commands() end";
      desc = "Commands";
    }
    {
      key = "<leader>lg";
      mode = "n";
      lua = true;
      action = "function() Snacks.lazygit() end";
      desc = "Lazygit";
    }
    {
      key = "K";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.hover() end";
      desc = "LSP hover";
    }
    {
      key = "gd";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.definition() end";
      desc = "Go to definition";
    }
    {
      key = "gD";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.declaration() end";
      desc = "Go to declaration";
    }
    {
      key = "gi";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.implementation() end";
      desc = "Go to implementation";
    }
    {
      key = "gr";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.references() end";
      desc = "Go to references";
    }
    {
      key = "gt";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.type_definition() end";
      desc = "Go to type definition";
    }
    {
      key = "<leader>rn";
      mode = "n";
      lua = true;
      action = "function() vim.lsp.buf.rename() end";
      desc = "Rename symbol";
    }
    {
      key = "<leader>ca";
      mode = [
        "n"
        "v"
      ];
      lua = true;
      action = "function() vim.lsp.buf.code_action() end";
      desc = "Code action";
    }
    {
      key = "gl";
      mode = "n";
      lua = true;
      action = "function() vim.diagnostic.open_float() end";
      desc = "Show diagnostics";
    }
    {
      key = "[d";
      mode = "n";
      lua = true;
      action = "function() vim.diagnostic.goto_prev() end";
      desc = "Previous diagnostic";
    }
    {
      key = "]d";
      mode = "n";
      lua = true;
      action = "function() vim.diagnostic.goto_next() end";
      desc = "Next diagnostic";
    }
    {
      key = "<leader>dl";
      mode = "n";
      lua = true;
      action = "function() vim.diagnostic.setloclist() end";
      desc = "Diagnostics to location list";
    }
    {
      key = "<leader>f";
      mode = [
        "n"
        "v"
      ];
      lua = true;
      action = ''
        function()
          require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end
      '';
      desc = "Format file or range";
    }
    {
      key = "<leader>W";
      mode = "n";
      action = ":noautocmd write<CR>";
      desc = "Save without formatting";
    }
    {
      key = "<leader>Y";
      mode = "n";
      lua = true;
      action = ''function() _G.copy_with_file_and_lines("line") end'';
      desc = "Copy current line with file and line range";
    }
    {
      key = "<leader>Y";
      mode = "v";
      lua = true;
      action = ''function() _G.copy_with_file_and_lines("visual") end'';
      desc = "Copy selection with file and line range";
    }
    {
      key = "<leader>/";
      mode = "n";
      lua = true;
      action = ''function() require("Comment.api").toggle.linewise.current() end'';
      desc = "Toggle comment";
    }
    {
      key = "<leader>/";
      mode = "v";
      action = "<ESC><cmd>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>";
      desc = "Toggle comment";
    }
    {
      key = "<leader>t";
      mode = "n";
      lua = true;
      action = ''
        function()
          local api = require("nvim-tree.api")
          local winid = api.tree.winid()

          if not winid then
            vim.notify("nvim-tree is not open", vim.log.levels.WARN)
            return
          end

          vim.notify("Tree resize mode: +/- to resize, Esc to exit", vim.log.levels.INFO)

          local function increase()
            local w = api.tree.winid()
            if w then
              local width = vim.api.nvim_win_get_width(w)
              vim.api.nvim_win_set_width(w, width + 5)
            end
          end

          local function decrease()
            local w = api.tree.winid()
            if w then
              local width = vim.api.nvim_win_get_width(w)
              vim.api.nvim_win_set_width(w, math.max(width - 5, 10))
            end
          end

          local function exit_resize_mode()
            vim.keymap.del("n", "+", { buffer = 0 })
            vim.keymap.del("n", "-", { buffer = 0 })
            vim.keymap.del("n", "=", { buffer = 0 })
            vim.keymap.del("n", "<Esc>", { buffer = 0 })
            vim.notify("Exited tree resize mode", vim.log.levels.INFO)
          end

          vim.keymap.set("n", "+", increase, { buffer = 0, nowait = true })
          vim.keymap.set("n", "=", increase, { buffer = 0, nowait = true })
          vim.keymap.set("n", "-", decrease, { buffer = 0, nowait = true })
          vim.keymap.set("n", "<Esc>", exit_resize_mode, { buffer = 0, nowait = true })
        end
      '';
      desc = "Enter tree resize mode";
    }
  ];
}
