{ ... }:

{
  programs.nvf.settings.vim.lsp = {
    enable = true;
    formatOnSave = false;
  };

  programs.nvf.settings.vim.languages = {
    enableTreesitter = true;

    bash.enable = true;
    clang.enable = true;
    css.enable = true;
    html = {
      enable = true;
      treesitter.autotagHtml = true;
    };
    json.enable = true;
    lua = {
      enable = true;
      lsp.lazydev.enable = true;
    };
    markdown.enable = true;
    nix.enable = true;
    python.enable = true;
    tex.enable = true;
    typescript.enable = true;
    yaml.enable = true;
  };
}
