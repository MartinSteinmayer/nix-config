{ lib, ... }:

{
  programs.nvf.settings.vim.ui.illuminate = {
    enable = true;
    setupOpts = {
      providers = [
        "lsp"
        "treesitter"
        "regex"
      ];
      delay = 100;
      filetype_overrides = { };
      filetypes_denylist = [
        "dirbuf"
        "dirvish"
        "fugitive"
      ];
      filetypes_allowlist = [ ];
      modes_denylist = [ ];
      modes_allowlist = [ ];
      providers_regex_syntax_denylist = [ ];
      providers_regex_syntax_allowlist = [ ];
      under_cursor = true;
      large_file_cutoff = 10000;
      large_file_overrides = null;
      min_count_to_highlight = 1;
      should_enable = lib.generators.mkLuaInline ''
        function(bufnr)
          return true
        end
      '';
      case_insensitive_regex = false;
      disable_keymaps = false;
    };
  };
}
