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

  networking.hosts = {
    "127.0.0.1" = [
      "tiltifydev.com"
      "api.tiltifydev.com"
      "v5api.tiltifydev.com"
      "id.tiltifydev.com"
      "app.tilitfydev.com"
      "start.tiltifydev.com"
      "donate.tiltifydev.com"
      ];
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker"];
    shell = pkgs.fish;
  };

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

  programs.fish.enable = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
  };

  programs.gamemode.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  virtualisation.docker.enable = true;

  networking.interfaces.enp7s0.ipv4.routes = [
    { address = "192.168.1.0"; prefixLength = 24; via = "192.168.5.1"; }
  ];

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
    fnm
    twitch-cli
    btop
    kdePackages.dolphin
    kdePackages.qtsvg
    azure-cli
    k9s
    kubectl
    kubelogin
  ];

  # Hint Electron/Chromium apps to run natively on Wayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "25.05";
}
