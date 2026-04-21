{ pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.username = "martin";
  home.homeDirectory = "/home/martin";

  home.stateVersion = "25.11";

home.pointerCursor = {
  gtk.enable = true;
  x11.enable = true;
  package = pkgs.bibata-cursors;
  name = "Bibata-Modern-Classic";
  size = 16;
};

fonts.fontconfig = {
  enable = true;
  antialias = true;
  hinting = {
    enable = true;
    style = "slight";
  };
  subpixel = {
    rgba = "rgb";
    lcdfilter = "default";
  };
};

gtk = {
  enable = true;
  cursorTheme = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };

  gtk3.extraConfig = {
    "gtk-cursor-theme-name" = "Bibata-Modern-Classic";
  };

  gtk4.extraConfig = {
    Settings = ''
      gtk-cursor-theme-name=Bibata-Modern-Classic
    '';
  };
};
  home.packages =
    with pkgs;
    [
      git
      neovim
      wget
      tree
      yazi
      opencode
    ]
    ++ lib.optionals isLinux [
      gcc
      kitty
      waybar
      nautilus
    ];

  programs = {
    zsh = {
      enable = true;

      shellAliases =
        {
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
          
          edit = "sudo -e";
        }
        // lib.optionalAttrs isLinux {
          update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-vm";
          off = "gdbus call --session --dest org.gnome.ScreenSaver --object-path /org/gnome/ScreenSaver --method org.gnome.ScreenSaver.SetActive true";
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
        plugins = [ "git" "z" "bgnotify" "colorize" ];
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
    walker = {
      enable = true;
      runAsService = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
