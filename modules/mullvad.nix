{ config, pkgs, lib, ... }:

{
  # Mullvad daemon + GUI app. The daemon (mullvad-daemon) runs as a system
  # service; the GUI/CLI talk to it. Connect with `mullvad account login <num>`
  # then `mullvad connect`, or use the tray app.
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;   # GUI app; use pkgs.mullvad for CLI-only
  };

  # Mullvad supports WireGuard and OpenVPN; WireGuard needs the kernel module,
  # which is present in modern kernels. Nothing else to do here.

  # NOTE ON THE FIREWALL:
  # Mullvad ships its own kill-switch / lockdown firewall (managed by the daemon
  # via nftables). It coexists with the NixOS firewall in modules/firewall.nix.
  # If you enable Mullvad's "Local network sharing", make sure your LAN subnet is
  # reachable in the firewall (it is, for outbound; inbound stays denied by default).
}
