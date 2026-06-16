# NixOS — Hyprland (illogical-impulse) + NVIDIA + Mullvad + firewall

A flake-based NixOS configuration that gives you:

- **Hyprland** desktop via [`soymou/illogical-flake`](https://github.com/soymou/illogical-flake)
  (end-4's *Illogical Impulse* dotfiles + QuickShell), wired in through home-manager
- **NVIDIA** proprietary driver with Wayland/KMS support
- **Mullvad VPN** (daemon + GUI)
- A **full-fledged nftables firewall**

## Layout

```
nixos-config/
├── flake.nix                  inputs + nixosConfigurations
├── configuration.nix          system glue (users, audio, DM, fonts, ...)
├── hardware-configuration.nix  PLACEHOLDER — regenerate on your machine
├── home.nix                   home-manager: enables programs.illogical-impulse
└── modules/
    ├── nvidia.nix
    ├── hyprland.nix
    ├── mullvad.nix
    └── firewall.nix
```

## Before you build

1. **Set your identity** in `flake.nix`:
   ```nix
   username = "youruser";
   hostname = "nixos";
   ```
2. **Generate real hardware config** on the target machine and replace the stub:
   ```bash
   sudo nixos-generate-config --dir .
   ```
   (The included `hardware-configuration.nix` is a non-bootable placeholder.)
3. **Check the NVIDIA driver type** in `modules/nvidia.nix`:
   - `open = true` for RTX 20xx / GTX 16xx **or newer** (Turing+)
   - `open = false` for GTX 10xx **and older** (Pascal and earlier)
4. Set your real `time.timeZone` in `configuration.nix`.

## Build / switch

Copy the folder to `/etc/nixos` (or keep it anywhere and point `--flake` at it):

> **First switch into Determinate Nix only.** Because the current system doesn't
> have Determinate's binary cache configured yet, the *initial* rebuild needs two
> extra flags so it can fetch Determinate Nix:
>
> ```bash
> sudo nixos-rebuild switch \
>   --option extra-substituters https://install.determinate.systems \
>   --option extra-trusted-public-keys cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= \
>   --flake .#nixos
> ```

Every rebuild after that is just:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Replace `nixos` with your `hostname` if you changed it.

### Don't have Nix/NixOS yet?

If you're starting from a non-NixOS machine, install Determinate Nix first with
the official installer, then build the flake:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

Or use Determinate's NixOS ISO. Either way, once Determinate Nix is present the
two extra flags above aren't needed.

## After first boot

- Log in via SDDM and pick the **Hyprland** session.
- Connect the VPN: `mullvad account login <ACCOUNT_NUMBER>` then `mullvad connect`
  (or use the tray GUI).

## Notes

- **Firewall + Mullvad**: Mullvad runs its own nftables kill-switch from its
  daemon; it coexists with the NixOS firewall here. `checkReversePath` is set to
  `"loose"` so VPN return traffic isn't dropped.
- **SSH is disabled by default.** To enable it, uncomment the `services.openssh`
  block *and* the SSH rate-limit rule in `modules/firewall.nix`.
- **UWSM**: Hyprland launches via UWSM. Do not also enable home-manager's
  `wayland.windowManager.hyprland.systemd.enable` — it conflicts.
- **Updating Determinate Nix**: the Nix daemon updates itself out-of-band
  (`sudo determinate-nixd upgrade`). To pull a newer pinned Determinate flake
  module, run `nix flake update determinate` and rebuild.
- This targets `nixos-unstable`. Keep `system.stateVersion` / `home.stateVersion`
  at the value from your original install.
