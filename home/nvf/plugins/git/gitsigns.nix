{ ... }:

{
  programs.nvf.settings.vim.git.gitsigns = {
    enable = true;
    mappings = {
      nextHunk = "]c";
      previousHunk = "[c";
      stageHunk = "<leader>hs";
      resetHunk = "<leader>hr";
      stageBuffer = "<leader>hS";
      resetBuffer = "<leader>hR";
      previewHunk = "<leader>hp";
      blameLine = "<leader>hb";
      toggleBlame = "<leader>hB";
      diffThis = "<leader>hd";
      diffProject = "<leader>hD";
    };
    setupOpts = {
      signs = {
        add.text = "│";
        change.text = "│";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
        untracked.text = "┆";
      };
      signcolumn = true;
      numhl = false;
      linehl = false;
      word_diff = false;
      watch_gitdir = {
        interval = 1000;
        follow_files = true;
      };
      attach_to_untracked = true;
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 1000;
        ignore_whitespace = false;
      };
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
      sign_priority = 6;
      update_debounce = 100;
      status_formatter = null;
      max_file_length = 40000;
      preview_config = {
        border = "single";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      };
    };
  };
}
