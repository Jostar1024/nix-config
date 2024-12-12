{
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "yuchengcao";
  home.homeDirectory = "/Users/yuchengcao";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    emacs
    iterm2
    darwin.iproute2mac
    rectangle
    raycast
    stats
    pgcli
    postgresql_17_jit
  ];

  programs.home-manager.enable = true;
}
