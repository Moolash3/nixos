{ config, pkgs, lib, ... }:

{
  # System-level Hyprland: installs it, sets up the wayland session file the
  # display manager uses, and adds the polkit/portal/dbus glue.
  programs.hyprland = {
    enable = true;
    withUWSM = true;        # launch via Universal Wayland Session Manager (recommended)
    xwayland.enable = true; # run X11 apps under Hyprland
  };

  # XDG portals. The Hyprland module pulls in xdg-desktop-portal-hyprland; gtk is
  # a useful fallback for file pickers etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit authentication agent (needed for privilege prompts in a Wayland session).
  security.polkit.enable = true;

  # A few wayland utilities most setups want. illogical-impulse provides the rest
  # (fuzzel, wlogout, hyprshot, hyprpicker, hypridle, hyprlock, ...) via home-manager.
  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
    playerctl
  ];
}
