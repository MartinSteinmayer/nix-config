{ ... }:

{
  programs.nvf.settings.vim.autocomplete."blink-cmp" = {
    enable = true;
    setupOpts = {
      keymap = {
        preset = "none";
        "<C-d>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<C-Space>" = [ "show" ];
        "<C-e>" = [
          "hide"
          "fallback"
        ];
        "<CR>" = [
          "select_and_accept"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
      };
      appearance.nerd_font_variant = "mono";
      completion.documentation.auto_show = true;
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
      fuzzy.implementation = "prefer_rust_with_warning";
    };
  };
}
