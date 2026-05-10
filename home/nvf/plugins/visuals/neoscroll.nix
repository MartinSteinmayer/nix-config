{ pkgs, ... }:

{
  programs.nvf.settings.vim.extraPlugins.neoscroll = {
    package = pkgs.vimPlugins."neoscroll-nvim";
    setup = ''
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>" },
        hide_cursor = false,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        duration_multiplier = 0.2,
        easing = "cubic",
      })
    '';
  };
}
