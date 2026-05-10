{ pkgs, ... }:

{
  programs.nvf.settings.vim.extraPlugins.persistence = {
    package = pkgs.vimPlugins."persistence-nvim";
    setup = ''
      require("persistence").setup({})
    '';
  };

  programs.nvf.settings.vim.keymaps = [
    {
      key = "<leader>ls";
      mode = "n";
      lua = true;
      action = "function() require(\"persistence\").load() end";
      desc = "Restore Session";
    }
    {
      key = "<leader>ll";
      mode = "n";
      lua = true;
      action = "function() require(\"persistence\").select() end";
      desc = "Select Session";
    }
    {
      key = "<leader>lL";
      mode = "n";
      lua = true;
      action = "function() require(\"persistence\").load({ last = true }) end";
      desc = "Restore Last Session";
    }
    {
      key = "<leader>ld";
      mode = "n";
      lua = true;
      action = "function() require(\"persistence\").stop() end";
      desc = "Don't Save Current Session";
    }
  ];
}
