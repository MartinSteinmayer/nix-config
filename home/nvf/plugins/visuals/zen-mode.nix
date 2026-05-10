{ pkgs, ... }:

{
  programs.nvf.settings.vim.extraPlugins.zen-mode = {
    package = pkgs.vimPlugins."zen-mode-nvim";
    setup = ''
      require("zen-mode").setup({
        window = {
          backdrop = 0.95,
          width = 120,
          height = 1,
          options = {},
        },
        plugins = {
          options = {
            enabled = true,
            ruler = false,
            showcmd = false,
            laststatus = 0,
          },
          twilight = { enabled = true },
          gitsigns = { enabled = false },
          todo = { enabled = false },
          kitty = {
            enabled = false,
            font = "+4",
          },
        },
        on_open = function(win)
        end,
        on_close = function()
        end,
      })
    '';
  };
}
