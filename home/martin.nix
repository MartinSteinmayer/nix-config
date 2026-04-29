{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.username = "martin";
  home.homeDirectory = "/home/martin";

  home.stateVersion = "25.11";

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 16;
  };

  gtk = {
    enable = true;
    gtk4.theme = null;

    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-gtk-theme";
    };

    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine-icon-theme-unstable";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  home.packages =
    with pkgs;
    [
      git
      anki
      gh
      wget
      tree
      yazi
      inputs.llm-agents.packages.${pkgs.system}.opencode
      inputs.llm-agents.packages.${pkgs.system}.pi
      ripgrep
      todoist
      kitty
      fzf
      gcc
      spotify
      texliveFull
      todoist-electron
    ]
    ++ lib.optionals isLinux [
      teams-for-linux
      wlr-randr
      nautilus
      grim
      slurp
      wl-clipboard
      pavucontrol
      pamixer
      rose-pine-hyprcursor
      bluez-tools
      blueman
    ];

  programs = {
    vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
      ];
    };

    nvf = {
      enable = true;
      defaultEditor = true;

      settings.vim = {
        viAlias = true;
        vimAlias = true;

        theme = {
          enable = true;
          name = "rose-pine";
          style = "moon";
          transparent = true;
        };

        lsp = {
          enable = true;
          formatOnSave = false;
        };

        languages = {
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

        treesitter.enable = true;

        autocomplete."blink-cmp" = {
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

        formatter."conform-nvim" = {
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
              yaml = [ "prettier" ];
              markdown = [ "prettier" ];
              lua = [ "stylua" ];
              python = [ "yapf" ];
              cpp = [ "clang_format" ];
              c = [ "clang_format" ];
            };
            formatters.prettier = {
              require_cwd = true;
              prepend_args = [
                "--config-precedence"
                "prefer-file"
              ];
            };
            format_on_save = {
              lsp_fallback = true;
              async = false;
              timeout_ms = 1000;
            };
          };
        };

        comments."comment-nvim" = {
          enable = true;
          setupOpts = {
            padding = true;
            sticky = true;
            toggler = {
              line = "gcc";
              block = "gbc";
            };
            opleader = {
              line = "gc";
              block = "gb";
            };
            mappings = {
              basic = true;
              extra = true;
            };
          };
        };

        visuals."nvim-web-devicons".enable = true;

        utility."snacks-nvim" = {
          enable = true;
          setupOpts = {
            picker = {
              enabled = true;
              matcher = {
                fuzzy = true;
                smartcase = true;
                filename_bonus = true;
              };
              layout.preset = "default";
              jump = {
                jumplist = true;
                close = true;
              };
              ui_select = true;
            };
            lazygit.enabled = true;
          };
        };

        filetree.nvimTree = {
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

        globals = {
          mapleader = " ";
        };

        options = {
          number = true;
          relativenumber = false;
          clipboard = "unnamedplus";
          syntax = "on";
          autoindent = true;
          cursorline = true;
          ignorecase = true;
          smartcase = true;
          expandtab = true;
          shiftwidth = 4;
          tabstop = 4;
          encoding = "UTF-8";
          ruler = true;
          mouse = "a";
          hidden = true;
          wildmenu = true;
          showmatch = true;
          splitright = true;
          splitbelow = true;
          termguicolors = true;
          guicursor = "n:block-blinkwait700-blinkon400-blinkoff250,i:block-blinkon0";
          wrap = false;
        };

        keymaps = [
          {
            key = "jk";
            mode = "i";
            action = "<Esc>";
            desc = "Exit insert mode";
          }
          {
            key = "<leader>ch";
            mode = "n";
            action = ":e ~/.config/nvim/nvim-cheatsheet.md<CR>";
            desc = "Open Neovim cheatsheet";
          }
          {
            key = "<C-t>";
            mode = "t";
            action = "<C-\\><C-n>";
            desc = "Exit terminal mode";
          }
          {
            key = "<leader>ww";
            mode = [
              "n"
              "t"
            ];
            lua = true;
            action = ''
              function()
                vim.wo.wrap = not vim.wo.wrap
              end
            '';
            desc = "Toggle word wrap locally";
          }
          {
            key = "<leader>ff";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.files() end";
            desc = "Find files";
          }
          {
            key = "<leader>fr";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.recent() end";
            desc = "Find recent files";
          }
          {
            key = "<leader>fb";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.buffers() end";
            desc = "Find buffers";
          }
          {
            key = "<leader>fg";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.grep() end";
            desc = "Live grep";
          }
          {
            key = "<leader>fw";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.grep_word() end";
            desc = "Search word under cursor";
          }
          {
            key = "<leader>:";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.command_history() end";
            desc = "Command history";
          }
          {
            key = "<leader>fs";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.git_status() end";
            desc = "Git status";
          }
          {
            key = "<leader>fc";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.git_log() end";
            desc = "Git commits";
          }
          {
            key = "<leader>fd";
            mode = "n";
            lua = true;
            action = ''
              function()
                local has_nvim_tree, api = pcall(require, "nvim-tree.api")
                if not has_nvim_tree then
                  vim.notify("nvim-tree is not available", vim.log.levels.ERROR)
                  return
                end

                Snacks.picker.pick({
                  title = "Directories",
                  finder = "proc",
                  cmd = "fd",
                  args = { "--type", "d", "--hidden", "--exclude", ".git" },
                  format = function(item)
                    return { { item.text, "Directory" } }
                  end,
                  preview = false,
                  confirm = function(picker, item)
                    picker:close()
                    if item then
                      api.tree.open()
                      api.tree.find_file(vim.fn.getcwd() .. "/" .. item.text)
                    end
                  end,
                })
              end
            '';
            desc = "Find directory and focus in tree";
          }
          {
            key = "<leader>fh";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.help() end";
            desc = "Help tags";
          }
          {
            key = "<leader>fk";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.keymaps() end";
            desc = "Keymaps";
          }
          {
            key = "<leader>fm";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.marks() end";
            desc = "Marks";
          }
          {
            key = "<leader>f:";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.commands() end";
            desc = "Commands";
          }
          {
            key = "<leader>lg";
            mode = "n";
            lua = true;
            action = "function() Snacks.lazygit() end";
            desc = "Lazygit";
          }
          {
            key = "K";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.hover() end";
            desc = "LSP hover";
          }
          {
            key = "gd";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.definition() end";
            desc = "Go to definition";
          }
          {
            key = "gD";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.declaration() end";
            desc = "Go to declaration";
          }
          {
            key = "gi";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.implementation() end";
            desc = "Go to implementation";
          }
          {
            key = "gr";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.references() end";
            desc = "Go to references";
          }
          {
            key = "gt";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.type_definition() end";
            desc = "Go to type definition";
          }
          {
            key = "<leader>rn";
            mode = "n";
            lua = true;
            action = "function() vim.lsp.buf.rename() end";
            desc = "Rename symbol";
          }
          {
            key = "<leader>ca";
            mode = [
              "n"
              "v"
            ];
            lua = true;
            action = "function() vim.lsp.buf.code_action() end";
            desc = "Code action";
          }
          {
            key = "gl";
            mode = "n";
            lua = true;
            action = "function() vim.diagnostic.open_float() end";
            desc = "Show diagnostics";
          }
          {
            key = "[d";
            mode = "n";
            lua = true;
            action = "function() vim.diagnostic.goto_prev() end";
            desc = "Previous diagnostic";
          }
          {
            key = "]d";
            mode = "n";
            lua = true;
            action = "function() vim.diagnostic.goto_next() end";
            desc = "Next diagnostic";
          }
          {
            key = "<leader>dl";
            mode = "n";
            lua = true;
            action = "function() vim.diagnostic.setloclist() end";
            desc = "Diagnostics to location list";
          }
          {
            key = "<leader>f";
            mode = [
              "n"
              "v"
            ];
            lua = true;
            action = ''
              function()
                require("conform").format({
                  lsp_fallback = true,
                  async = false,
                  timeout_ms = 1000,
                })
              end
            '';
            desc = "Format file or range";
          }
          {
            key = "<leader>/";
            mode = "n";
            lua = true;
            action = ''function() require("Comment.api").toggle.linewise.current() end'';
            desc = "Toggle comment";
          }
          {
            key = "<leader>/";
            mode = "v";
            action = "<ESC><cmd>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>";
            desc = "Toggle comment";
          }
          {
            key = "<leader>t";
            mode = "n";
            lua = true;
            action = ''
              function()
                local api = require("nvim-tree.api")
                local winid = api.tree.winid()

                if not winid then
                  vim.notify("nvim-tree is not open", vim.log.levels.WARN)
                  return
                end

                vim.notify("Tree resize mode: +/- to resize, Esc to exit", vim.log.levels.INFO)

                local function increase()
                  local w = api.tree.winid()
                  if w then
                    local width = vim.api.nvim_win_get_width(w)
                    vim.api.nvim_win_set_width(w, width + 5)
                  end
                end

                local function decrease()
                  local w = api.tree.winid()
                  if w then
                    local width = vim.api.nvim_win_get_width(w)
                    vim.api.nvim_win_set_width(w, math.max(width - 5, 10))
                  end
                end

                local function exit_resize_mode()
                  vim.keymap.del("n", "+", { buffer = 0 })
                  vim.keymap.del("n", "-", { buffer = 0 })
                  vim.keymap.del("n", "=", { buffer = 0 })
                  vim.keymap.del("n", "<Esc>", { buffer = 0 })
                  vim.notify("Exited tree resize mode", vim.log.levels.INFO)
                end

                vim.keymap.set("n", "+", increase, { buffer = 0, nowait = true })
                vim.keymap.set("n", "=", increase, { buffer = 0, nowait = true })
                vim.keymap.set("n", "-", decrease, { buffer = 0, nowait = true })
                vim.keymap.set("n", "<Esc>", exit_resize_mode, { buffer = 0, nowait = true })
              end
            '';
            desc = "Enter tree resize mode";
          }
        ];

        augroups = [
          {
            name = "MartinNvf";
            clear = true;
          }
        ];

        autocmds = [
          {
            event = [ "TermOpen" ];
            pattern = [ "*" ];
            group = "MartinNvf";
            desc = "Let terminal buffers use space normally";
            callback = lib.generators.mkLuaInline ''
              function(args)
                vim.keymap.set("t", "<Space>", "<Space>", {
                  buffer = args.buf,
                  nowait = true,
                })
              end
            '';
          }
          {
            event = [ "FileType" ];
            pattern = [ "markdown" ];
            group = "MartinNvf";
            desc = "Markdown preview keymap";
            callback = lib.generators.mkLuaInline ''
              function(args)
                vim.keymap.set("n", "<leader>mp", "<cmd>MdOpen<CR>", {
                  buffer = args.buf,
                  silent = true,
                  desc = "Markdown Preview",
                })
              end
            '';
          }
          {
            event = [ "FileType" ];
            pattern = [
              "markdown"
              "tex"
              "plaintex"
            ];
            group = "MartinNvf";
            desc = "Disable line numbers for prose buffers";
            command = "setlocal nonumber norelativenumber";
          }
        ];

        luaConfigRC = {
          lspServers = ''
            vim.lsp.config("eslint", {
              root_dir = function(fname)
                local util = require("lspconfig.util")
                return util.root_pattern("pnpm-workspace.yaml", "lerna.json", ".git")(fname)
              end,
            })
            vim.lsp.enable("eslint")

            vim.lsp.config("tailwindcss", {})
            vim.lsp.enable("tailwindcss")

            vim.lsp.config("copilot", {})
            vim.lsp.enable("copilot")
          '';

          customCommands = ''
            vim.api.nvim_create_user_command("Cppath", function()
              local path = vim.fn.expand("%:p")
              vim.fn.setreg("+", path)
              vim.notify('Copied "' .. path .. '" to the clipboard!')
            end, {})

            vim.api.nvim_create_user_command("MdOpen", function()
              local input = vim.fn.expand("%:p")
              local base = vim.fn.expand("%:t:r")

              local outdir = vim.fn.expand("~/Documents/md-preview")
              vim.fn.mkdir(outdir, "p")

              local out = outdir .. "/" .. base .. ".html"

              vim.fn.system({ "pandoc", input, "-s", "-o", out })
              vim.fn.jobstart({ "xdg-open", out }, { detach = true })
            end, {})
          '';
        };

        lsp.servers.lua-language-server.settings = {
          Lua = {
            diagnostics.globals = [ "vim" ];
            workspace.checkThirdParty = false;
          };
        };
      };
    };

    zsh = {
      enable = true;

      shellAliases = {
        ll = "ls -l";
        l = "ls -lh";
        la = "ls -lah";
        ".." = "cd ..";
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";
        df = "df -h";
        du = "du -h";
        vim = "nvim";

        # Custom directory shortcuts
        docs = "cd ~/Documents";
        dl = "cd ~/Downloads";
        tum = "cd ~/Documents/TUM";
        notes = "cd ~/Documents/Notes";
        masters = "cd ~/Documents/TUM/Masters";
        itdl = "cd ~/Documents/TUM/Masters/1.Semester/ITDL";
        dse = "cd ~/Documents/TUM/Masters/1.Semester/DSE";
      }
      // lib.optionalAttrs isLinux {
        update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      };

      initContent = ''
        # Custom functions
        function mkcd() {
          mkdir -p "$@" && cd "$@"
        }

        function top5() { ps aux --sort=-%mem | head -n 6; }
        function topcpu() { ps aux --sort=-%cpu | head -n 6; }

        function open() {
            xdg-open "$1" &> /dev/null &
        }

        # Cursor shape for different vi modes
        function zle-keymap-select {
          if [[ ''${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
            echo -ne '\e[1 q'  # Blinking block for normal mode
          elif [[ "''${KEYMAP}" == "main" ]] || [[ "''${KEYMAP}" == "viins" ]] || [[ "''${KEYMAP}" == "" ]] || [[ "$1" == "beam" ]]; then
            echo -ne '\e[2 q'  # Static block for insert mode
          fi
        }
        zle -N zle-keymap-select

        # Initialize cursor on new prompt
        function zle-line-init {
          echo -ne '\e[2 q'  # Start with static block (insert mode)
        }
        zle -N zle-line-init

        # Extract archives
        extract() {
            if [ -f "$1" ] ; then
                case $1 in
                    *.tar.bz2)   tar xjf "$1"    ;;
                    *.tar.gz)    tar xzf "$1"    ;;
                    *.bz2)       bunzip2 "$1"    ;;
                    *.rar)       unrar x "$1"    ;;
                    *.gz)        gunzip "$1"     ;;
                    *.tar)       tar xf "$1"     ;;
                    *.tbz2)      tar xjf "$1"    ;;
                    *.tgz)       tar xzf "$1"    ;;
                    *.zip)       unzip "$1"      ;;
                    *.Z)         uncompress "$1" ;;
                    *.7z)        7z x "$1"       ;;
                    *)           echo "'$1' cannot be extracted via extract()" ;;
                esac
            else
                echo "'$1' is not a valid file"
            fi
        }

        set -o vi
        bindkey -M viins 'jk' vi-cmd-mode
        setopt IGNORE_EOF
      '';

      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "z"
          "bgnotify"
          "colorize"
        ];
      };

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            sha256 = "1yl8zdip1z9inp280sfa5byjbf2vqh2iazsycar987khjsi5d5w8";
          };
        }
      ];
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
    };

    starship = {
      enable = true;
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/etc/nixos"; # sets NH_OS_FLAKE variable for you
    };

    waybar = {
      enable = true;
      systemd.enable = true;

      settings = [
        {
          layer = "top";
          position = "top";
          height = 32;

          "modules-left" = [ "hyprland/workspaces" ];
          "modules-center" = [ "clock" ];
          "modules-right" = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "tray"
          ];

          "hyprland/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
          };

          clock = {
            format = "{:%H:%M}";
            "tooltip-format" = "{:%A, %d %B %Y}";
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            "format-muted" = "󰖁  muted";
            "format-icons" = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            "on-click" = "pavucontrol";
            "on-click-right" = "pamixer -t";
            "scroll-step" = 5;
          };

          network = {
            "format-wifi" = "  {signalStrength}%";
            "format-ethernet" = "󰈀  Connected";
            "format-disconnected" = "  Offline";
          };

          cpu = {
            format = "  {usage}%";
          };

          memory = {
            format = "  {used}GB";
          };

          tray = {
            spacing = 10;
          };
        }
      ];

      style = ''
        * {
          font-family: JetBrainsMono, monospace;
          font-size: 13px;
          border: none;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
          color: #e0def4;
        }

        .modules-left,
        .modules-center,
        .modules-right {
          margin: 8px 10px 0;
          padding: 4px 8px;
          border-radius: 12px;
          background: rgba(31, 29, 46, 0.72);
          border: 1px solid rgba(144, 140, 170, 0.35);
        }

        #workspaces button {
          margin: 0 4px;
          padding: 0 10px;
          border-radius: 8px;
          color: #908caa;
          transition: all 150ms ease;
        }

        #workspaces button:hover {
          color: #e0def4;
          background: rgba(38, 35, 58, 0.85);
        }

        #workspaces button.active {
          color: #191724;
          background: #c4a7e7;
        }

        #clock,
        #pulseaudio,
        #network,
        #cpu,
        #memory,
        #tray {
          margin: 0 4px;
          padding: 0 10px;
          border-radius: 8px;
          color: #e0def4;
          background: rgba(38, 35, 58, 0.55);
        }

        #network.disconnected {
          color: #eb6f92;
        }
      '';
    };

    walker = {
      enable = true;
      runAsService = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = false;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [
          {
            monitor = "";
            path = "${./wallpapers/rose-pine-moon-wallpaper.jpeg}";
          }
        ];
        splash = false;
      };
    };
    mako = {
      enable = true;
    };
  };

}
