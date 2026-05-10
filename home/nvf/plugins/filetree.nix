{ lib, ... }:

{
  programs.nvf.settings.vim.filetree.nvimTree = {
    enable = true;
    mappings = {
      toggle = "<C-n>";
      refresh = null;
      findFile = null;
      focus = null;
    };
    setupOpts = {
      on_attach = lib.generators.mkLuaInline ''
        function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          local function change_root_to_node()
            local node = api.tree.get_node_under_cursor()
            if node and node.type == "directory" then
              api.tree.change_root(node.absolute_path)
            elseif node and node.parent then
              api.tree.change_root(node.parent.absolute_path)
            end
          end

          local function live_grep_in_directory()
            local node = api.tree.get_node_under_cursor()
            local dir_path = nil

            if node and node.type == "directory" then
              dir_path = node.absolute_path
            elseif node and node.parent then
              dir_path = node.parent.absolute_path
            end

            if dir_path then
              Snacks.picker.grep({ cwd = dir_path })
            else
              vim.notify("No directory found under cursor", vim.log.levels.WARN)
            end
          end

          local function copy_relative_path()
            local node = api.tree.get_node_under_cursor()
            if node then
              local tree_root = api.tree.get_nodes().absolute_path
              local relative_path = node.absolute_path:gsub("^" .. vim.pesc(tree_root) .. "/", "")
              vim.fn.setreg("+", relative_path)
              vim.notify("Copied: " .. relative_path, vim.log.levels.INFO)
            end
          end

          vim.keymap.set("n", "<C-]>", change_root_to_node, opts("CD to directory under cursor"))
          vim.keymap.set("n", "<leader>sd", live_grep_in_directory, opts("Live grep in directory under cursor"))
          vim.keymap.set("n", "Y", copy_relative_path, opts("Copy relative path to clipboard"))

          if not vim.g.martin_nvim_tree_setup_done then
            vim.g.martin_nvim_tree_setup_done = true

            vim.api.nvim_create_augroup("save_nvim_tree_width", { clear = true })
            vim.api.nvim_create_autocmd("WinResized", {
              group = "save_nvim_tree_width",
              pattern = "*",
              callback = function()
                local winid = api.tree.winid()
                if winid ~= nil and vim.tbl_contains(vim.v.event.windows, winid) then
                  vim.t.filetree_width = vim.api.nvim_win_get_width(winid)
                end
              end,
            })

            api.events.subscribe(api.events.Event.TreeOpen, function()
              if vim.t.filetree_width ~= nil then
                local winid = api.tree.winid()
                vim.api.nvim_win_set_width(winid, vim.t.filetree_width)
              end
            end)
          end
        end
      '';
      filters = {
        dotfiles = false;
        git_ignored = false;
        exclude = [ ];
      };
      view.width = 30;
      actions.open_file.resize_window = false;
      update_focused_file.enable = true;
    };
  };
}
