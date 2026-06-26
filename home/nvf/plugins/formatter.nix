{ ... }:

{
  programs.nvf.settings.vim.formatter."conform-nvim" = {
    enable = true;
    setupOpts = {
      formatters_by_ft = {
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        css = [ "prettier" ];
        html = [ "prettier" ];
        astro = [ "prettier" ];
        json = [ "prettier" ];
        xml = [ "prettier" ];
        yaml = [ "prettier" ];
        markdown = [ "prettier" ];
        nix = [ "alejandra" ];
        lua = [ "stylua" ];
        python = [ "yapf" ];
        cpp = [ "clang-format" ];
        c = [ "clang-format" ];
      };
      formatters = {
        prettier = {
          require_cwd = true;
          prepend_args = [
            "--config-precedence"
            "file-override"
            "--tab-width"
            "4"
          ];
        };
        "clang-format" = {
          prepend_args = [
            "--style=file"
            "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4}"
          ];
        };
      };
      format_on_save = {
        lsp_fallback = true;
        async = false;
        timeout_ms = 1000;
      };
    };
  };
}
