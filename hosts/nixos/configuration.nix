{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  # Boot 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;  
  users.users.martin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs = {
    zsh.enable = true;
    firefox.enable = true;
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
        extraPackages = [];
    };
    bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
  };

  services = {
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
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "25.11";
}
