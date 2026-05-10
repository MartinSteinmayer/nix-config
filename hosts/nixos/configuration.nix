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

  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 0;
    "kernel.perf_event_paranoid" = -1;
  };

  users.users.martin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
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
  ];

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    nix-ld.enable = true;
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
      # Uncomment the following line if you want to use JACK applications
      # jack.enable = true;
    };
    xserver.videoDrivers = [ "nvidia" ];
    xserver.enable = true;
    pulseaudio.enable = false;
  };

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
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "25.11";
}
