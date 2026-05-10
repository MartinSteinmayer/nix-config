{ pkgs, ... }:

{
  programs.nvf.settings.vim.lazy.plugins.vimtex = {
    package = pkgs.vimPlugins.vimtex;
    lazy = false;
    beforeAll = ''
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_doc_confirm_single = 0
      vim.cmd([[ 
        function! OpenTexdocOnline(context)
          execute '!xdg-open "https://texdoc.org/pkg/' . a:context.name . '" >/dev/null 2>&1 &'
          return 1
        endfunction
      ]])
      vim.g.vimtex_doc_handlers = { "OpenTexdocOnline" }
    '';
  };
}
