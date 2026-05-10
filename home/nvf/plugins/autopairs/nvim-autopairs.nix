{ ... }:

{
  programs.nvf.settings.vim.autopairs.nvim-autopairs = {
    enable = true;
    setupOpts = {
      disable_filetype = [
        "TelescopePrompt"
        "vim"
      ];
      check_ts = true;
    };
  };
}
