{ ... }:

{
  programs.nvf.settings.vim.utility."snacks-nvim" = {
    enable = true;
    setupOpts = {
      picker = {
        enabled = true;
        matcher = {
          fuzzy = true;
          smartcase = true;
          filename_bonus = true;
        };
        layout.preset = "default";
        jump = {
          jumplist = true;
          close = true;
        };
        ui_select = true;
      };
      lazygit.enabled = true;
    };
  };
}
