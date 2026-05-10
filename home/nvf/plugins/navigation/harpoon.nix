{ ... }:

{
  programs.nvf.settings.vim.navigation.harpoon = {
    enable = true;
    mappings = {
      markFile = "<C-e>";
      listMarks = "<C-.>";
      file1 = "<leader>1";
      file2 = "<leader>2";
      file3 = "<leader>3";
      file4 = "<leader>4";
    };
    setupOpts = { };
  };

  programs.nvf.settings.vim.keymaps = [
    {
      key = "<C-]>";
      mode = "n";
      lua = true;
      action = "function() require(\"harpoon\"):list():prev() end";
      desc = "Harpoon: Previous";
    }
    {
      key = "<C-[>";
      mode = "n";
      lua = true;
      action = "function() require(\"harpoon\"):list():next() end";
      desc = "Harpoon: Next";
    }
  ];
}
