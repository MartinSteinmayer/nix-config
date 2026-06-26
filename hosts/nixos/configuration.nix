{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  # External filesystems

  fileSystems."/home/martin/Games" = {
    device = "/dev/disk/by-label/LinuxGames";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "mem_sleep_default=s2idle" ];
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 0;
    "kernel.perf_event_paranoid" = -1;
  };

  users.users.martin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = with pkgs; [
    perf
    gnumake
    libuuid
  ];

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
    gamescope = {
      enable = true;
      capSysNice = false;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-curses;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    yazi.enable = true;
  };

  nixpkgs.overlays = [
    (_final: prev: {
      nh = inputs.nh.packages.${prev.system}.default;
    })
  ];

  nixpkgs.config.allowUnfree = true;

  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    udev.extraRules = builtins.readFile ./rules/99-jlink.rules;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = false;
      };
      defaultSession = "hyprland-uwsm";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig."99-hdmi-audio" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_output.*"; }
            ];
            actions.update-props = {
              "session.suspend-timeout-seconds" = 0;
              "node.always-process" = true;
            };
          }
        ];
      };
      # Uncomment the following line if you want to use JACK applications
      # jack.enable = true;
    };
    xserver.videoDrivers = [ "nvidia" ];
    xserver.enable = true;
    pulseaudio.enable = false;
  };

  virtualisation.docker.enable = true;

  security.rtkit.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts._0xproto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-code-pro
      source-sans-pro
      source-serif-pro
      liberation_ttf
      dejavu_fonts
      corefonts
      google-fonts
      font-awesome
    ];

    fontconfig = {
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "slight";
      };
      defaultFonts = {
        serif = [
          "Source Serif Pro"
        ];
        sansSerif = [
          "Source Sans Pro"
        ];
        monospace = [
          "0xProto Nerd Font Mono"
        ];
      };
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  powerManagement.resumeCommands = ''
    logger "resume hook ran"
    echo 0000:05:00.1 > /sys/bus/pci/drivers/snd_hda_intel/unbind
    sleep 1
    echo 0000:05:00.1 > /sys/bus/pci/drivers/snd_hda_intel/bind
  '';

  system.stateVersion = "25.11";
}
