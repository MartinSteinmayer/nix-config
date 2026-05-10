{ lib, ... }:

{
  programs.nvf.settings.vim.utility.outline.aerial-nvim = {
    enable = true;
    setupOpts.on_attach = lib.generators.mkLuaInline ''
      function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end
    '';
  };

  programs.nvf.settings.vim.keymaps = [
    {
      key = "<M-a>";
      mode = "n";
      lua = true;
      action = "function() require(\"aerial\").snacks_picker() end";
      desc = "Aerial picker";
    }
  ];
}
