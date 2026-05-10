{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nvf.settings.vim.utility.images.image-nvim;
in
{
  programs.nvf.settings.vim.utility.images.image-nvim = {
    enable = true;
    setupOpts = {
      processor = "magick_cli";
      integrations.markdown = {
        enabled = true;
        only_render_image_at_cursor = true;
        only_render_image_at_cursor_mode = "popup";
      };
      max_height_window_percentage = 50;
    };
  };

  home.packages = lib.mkIf cfg.enable (
    with pkgs;
    [
      ueberzugpp
      imagemagick
    ]
  );
}
