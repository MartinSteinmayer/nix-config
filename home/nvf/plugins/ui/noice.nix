{ ... }:

{
  programs.nvf.settings.vim.ui.noice = {
    enable = true;
    setupOpts = {
      routes = [
        {
          filter.event = "msg_show";
          opts.skip = true;
        }
        {
          filter.event = "msg_showmode";
          opts.skip = true;
        }
        {
          filter.event = "msg_showcmd";
          opts.skip = true;
        }
        {
          filter.event = "notify";
          opts.skip = true;
        }
      ];
      lsp.override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
      };
      presets = {
        bottom_search = false;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
        lsp_doc_border = false;
      };
      notify.enabled = false;
    };
  };
}
