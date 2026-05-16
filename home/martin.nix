{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
  obscura = pkgs.stdenvNoCC.mkDerivation {
    pname = "obscura";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "https://github.com/h4ckf0r0day/obscura/releases/download/v0.1.2/obscura-x86_64-linux.tar.gz";
      hash = "sha256-MHzliv/qP/OSI79XPPORyIg+CBHTbpzXGF+MfFSUKAI=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [
      pkgs.glibc
      pkgs.gcc.cc.lib
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp obscura obscura-worker $out/bin/
      chmod +x $out/bin/obscura $out/bin/obscura-worker
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Open-source headless browser for AI agents and web scraping";
      homepage = "https://github.com/h4ckf0r0day/obscura";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      mainProgram = "obscura";
    };
  };
in
{
  imports = [
    ./nvf
    ./noctalia/default.nix
  ];
  home.username = "martin";
  home.homeDirectory = "/home/martin";

  home.stateVersion = "25.11";

  home.sessionPath = [
    "/opt/SEGGER/JLink_Linux_V942_x86_64"
  ];

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
      anki-bin
      gh
      unzip
      wget
      vlc

      # Course: Embedded Systems
      gcc-arm-embedded

      tree
      yazi
      lazygit
      zellij
      inputs.llm-agents.packages.${pkgs.system}.opencode
      inputs.llm-agents.packages.${pkgs.system}.pi
      ripgrep
      todoist
      kitty
      fzf
      gcc
      ghostscript
      spotify
      texliveFull
      todoist-electron
      obscura
    ]
    ++ lib.optionals isLinux [
      teams-for-linux
      wlr-randr
      nautilus
      grim
      eduvpn-client
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
        parprog = "cd ~/Documents/TUM/Masters/1.Semester/Parprog";
        ess = "cd ~/Documents/TUM/Masters/1.Semester/ESS";
        enix = "cd ~/nixcfg/ && vim";
        cpi = "vim ~/.pi/agent/AGENTS.md";
        life = "cd ~/Documents/life/";
        pifig = "cd ~/.pi && vim ./agent/AGENTS.md";
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

  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
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
