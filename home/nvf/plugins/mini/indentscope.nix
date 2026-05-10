{ lib, ... }:

{
  programs.nvf.settings.vim.mini.indentscope = {
    enable = true;
    setupOpts = {
      draw = {
        delay = 50;
        animation = lib.generators.mkLuaInline ''
          function(s, n)
            return 10
          end
        '';
      };
    };
  };
}
