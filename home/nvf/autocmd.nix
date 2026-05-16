{ lib, ... }:

{
  programs.nvf.settings.vim.augroups = [
    {
      name = "MartinNvf";
      clear = true;
    }
  ];

  programs.nvf.settings.vim.autocmds = [
    {
      event = [ "TermOpen" ];
      pattern = [ "*" ];
      group = "MartinNvf";
      desc = "Let terminal buffers use space normally";
      callback = lib.generators.mkLuaInline ''
        function(args)
          vim.keymap.set("t", "<Space>", "<Space>", {
            buffer = args.buf,
            nowait = true,
          })
        end
      '';
    }
    {
      event = [ "FileType" ];
      pattern = [
        "nix"
        "cpp"
        "c"
      ];
      group = "MartinNvf";
      desc = "Use 2-space indentation for Nix buffers";
      command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2";
    }
    {
      event = [ "FileType" ];
      pattern = [ "markdown" ];
      group = "MartinNvf";
      desc = "Markdown preview keymap";
      callback = lib.generators.mkLuaInline ''
        function(args)
          vim.keymap.set("n", "<leader>mp", "<cmd>MdOpen<CR>", {
            buffer = args.buf,
            silent = true,
            desc = "Markdown Preview",
          })
        end
      '';
    }
    {
      event = [ "FileType" ];
      pattern = [
        "markdown"
        "tex"
        "plaintex"
      ];
      group = "MartinNvf";
      desc = "Disable line numbers for prose buffers";
      command = "setlocal nonumber norelativenumber";
    }
    {
      event = [ "TextYankPost" ];
      pattern = [ "*" ];
      group = "MartinNvf";
      desc = "Copy yanked source code with file and line range to system clipboard";
      callback = lib.generators.mkLuaInline ''
        function(args)
          if vim.v.event.operator ~= "y" then
            return
          end

          local buf = args.buf
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
            tex = true,
            rust = true,
            sh = true,
            toml = true,
            typescript = true,
            typescriptreact = true,
            yaml = true,
            zsh = true,
          }

          if not source_filetypes[ft] then
            return
          end

          local file = vim.api.nvim_buf_get_name(buf)
          if file == "" then
            return
          end

          local start_pos = vim.api.nvim_buf_get_mark(buf, "[")
          local end_pos = vim.api.nvim_buf_get_mark(buf, "]")
          local start_line = start_pos[1]
          local end_line = end_pos[1]

          if start_line == 0 or end_line == 0 then
            return
          end

          local relative_file = vim.fn.fnamemodify(file, ":.")
          local yanked = table.concat(vim.v.event.regcontents, "\n")
          local payload = string.format("%s(%d-%d): %s", relative_file, start_line, end_line, yanked)

          if vim.fn.executable("wl-copy") ~= 1 then
            return
          end

          local job = vim.fn.jobstart({ "wl-copy" }, { stdin = "pipe" })
          if job <= 0 then
            return
          end

          vim.fn.chansend(job, payload)
          vim.fn.chanclose(job, "stdin")
        end
      '';
    }
  ];
}
