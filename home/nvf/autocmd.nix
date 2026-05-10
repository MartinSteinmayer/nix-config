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
  ];
}
