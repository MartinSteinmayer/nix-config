{ ... }:

{
  programs.nvf.settings.vim.comments."comment-nvim" = {
    enable = true;
    setupOpts = {
      padding = true;
      sticky = true;
      toggler = {
        line = "gcc";
        block = "gbc";
      };
      opleader = {
        line = "gc";
        block = "gb";
      };
      mappings = {
        basic = true;
        extra = true;
      };
    };
  };
}
