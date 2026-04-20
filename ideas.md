# Ideas for changing my Nix config

Awesome — here’s the exact shape I’d apply, before touching files.
Plan
- Keep one shared HM base.
- Split Linux-only and Darwin-only HM bits.
- Wire HM into both nixosConfigurations and darwinConfigurations.
- Also expose standalone homeConfigurations so you can run HM without root on both machines.
Proposed File Changes
- Update flake.nix:
  - add nix-darwin input
  - add darwinConfigurations.<mac-host>
  - keep nixosConfigurations.nixos
  - switch HM user import to a small compositor module (home/martin.nix)
  - add standalone homeConfigurations entries
{
  description = "My NixOS + Home Manager config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ... }:
  let
    mkPkgs = system: import nixpkgs { inherit system; };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.sharedModules = [ inputs.walker.homeManagerModules.default ];
          home-manager.users.martin = import ./home/martin.nix;
        }
      ];
    };
    darwinConfigurations."<mac-host>" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # or x86_64-darwin
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.martin = import ./home/martin.nix;
        }
      ];
    };
    homeConfigurations."martin@nixos" = home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs "x86_64-linux";
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home/martin.nix inputs.walker.homeManagerModules.default ];
    };
    homeConfigurations."martin@mac" = home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs "aarch64-darwin"; # or x86_64-darwin
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home/martin.nix ];
    };
  };
}
- Replace home/martin.nix with a tiny composition module:
{ pkgs, ... }:
{
  imports = [
    ./shared.nix
    (if pkgs.stdenv.isLinux then ./linux.nix else ./darwin.nix)
  ];
}
- Add home/shared.nix (most of your current content: zsh, starship, yazi, common packages, aliases/functions, etc.).
  - home.homeDirectory should be platform-aware:
    - Linux: /home/martin
    - Darwin: /Users/martin
- Add home/linux.nix for Linux-only HM:
  - home.packages linux extras (gcc, kitty, waybar, nautilus)
  - wayland.windowManager.hyprland block (currently at home/martin.nix:158)
  - Linux-only alias bits if desired
- Add home/darwin.nix for macOS-only HM:
  - Darwin-specific packages/options (can start minimal/empty)
- Add hosts/darwin/configuration.nix (new nix-darwin host module).
How you’d use it
- NixOS full switch: sudo nixos-rebuild switch --flake /home/martin/nixcfg#nixos
- NixOS HM-only: home-manager switch --flake /home/martin/nixcfg#martin@nixos
- macOS full switch: darwin-rebuild switch --flake /home/martin/nixcfg#<mac-host>
- macOS HM-only: home-manager switch --flake /home/martin/nixcfg#martin@mac
If this structure looks good, I’ll make the patch next with placeholders for <mac-host> and Darwin system arch unless you want specific values now.
