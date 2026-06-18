{ config, pkgs, lib, inputs, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/hyprland.nix
    ./modules/mullvad.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = ["root" "@wheel"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker"];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];

  virtualisation.docker.enable = true;

  # ---- Services required by illogical-impulse / QuickShell -----------------
  services.geoclue2.enable = true;   # QtPositioning (weather, etc.)
  services.upower.enable = true;     # battery widgets

  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    alacritty
    firefox
    tmux
    neovim
    docker
    discord
    vesktop
    mise
    pinentry-curses
    gnupg
    clamav
    tree-sitter
    clang
    nodejs
    pnpm
    yarn
    gcc
    ncurses
    autoconf
    automake
    openssl
    gnumake
    erlang
    elixir
    postman
    dbeaver-bin
  ];

  # Hint Electron/Chromium apps to run natively on Wayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "25.05";
}
