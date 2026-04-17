{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-vm";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  users.users.martin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.yazi.enable = true;

  # For Walker and app discovery
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  services.spice-vdagentd.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Enable the walker daemon and fix the AMD graphics error
  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    mesa
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

  system.stateVersion = "25.11";
}
