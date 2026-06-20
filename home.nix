{ config, pkgs, lib, inputs, username, ... }:

{
  imports = [
    # The home-manager module exported by soymou/illogical-flake.
    inputs.illogical-flake.homeManagerModules.default
  ];

  # home.username / home.homeDirectory are set automatically because this is
  # loaded through the home-manager NixOS module.

  programs.illogical-impulse = {
    enable = true;

    # All of these are on by default; shown so you can flip any off.
    dotfiles = {
      fish.enable = true;      # fish shell config
    };
  };

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = null;
    };
  };

  programs.gpg.enable = true;

  # IMPORTANT: when using UWSM (set in modules/hyprland.nix) you must NOT also let
  # home-manager start a Hyprland systemd session, or the two will fight. The
  # illogical-impulse module doesn't enable that integration, so there's nothing
  # to disable here — just don't add `wayland.windowManager.hyprland.systemd.enable`.

  # Add your own user packages here.
  home.packages = with pkgs; [
    firefox
    tmux
    neovim
    docker
    mise
    pinentry-curses
    gnupg
    tree-sitter
    clang
    prisma
    prisma-engines
  ];

  home.sessionVariables = {
    PRISMA_SCHEMA_ENGINE_BINARY  = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY   = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY  = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY            = "${pkgs.prisma-engines}/bin/prisma-fmt";
  };

  home.stateVersion = "25.05";
}
