# AGENTS.md

## What this repo is
- Single-host NixOS flake with integrated Home Manager (no monorepo, no app/test pipeline).
- Only exported system is `nixosConfigurations.nixos` from `flake.nix`.

## Real entrypoints
- `flake.nix` wires everything: NixOS host module + Home Manager module.
- System config lives in `hosts/nixos/configuration.nix`.
- User config lives in `home/martin.nix`.
- Hyprland config is loaded from `home/hyprland.conf` via `builtins.readFile`.

## Verified commands
- Evaluate outputs: `nix flake show --no-write-lock-file`
- Check config evaluates: `nix flake check --no-write-lock-file`
- Apply system on this machine: `sudo nixos-rebuild switch --flake /home/martin/nixcfg#nixos`

## Gotchas worth remembering
- Do not trust the `update` shell alias in `home/martin.nix`; it targets `#nixos-vm`, which is not a flake output in this repo.
- Home Manager is embedded in the NixOS config here; there is no standalone `homeConfigurations` output to switch directly.
- Home Manager backup suffix is set to `hm-backup` (`home-manager.backupFileExtension`). Expect backup files after HM-managed file conflicts.
- `hosts/nixos/hardware-configuration.nix` is generated hardware state; keep edits in `hosts/nixos/configuration.nix` unless hardware regen is intentional.

## Current structure boundaries
- `hosts/` = machine-level NixOS modules.
- `home/` = user-level Home Manager modules/config files.
- `ideas.md` is planning scratchpad, not executable config.
