{ config, pkgs, lib, inputs, username, ... }:

{
  imports = [
    inputs.illogical-flake.homeManagerModules.default
  ];

  programs.illogical-impulse = {
    enable = true;

    dotfiles = {
      fish.enable = true;
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
