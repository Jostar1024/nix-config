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
    # postgres
    pgcli
    postgresql_16
    pgformatter
  ];

  programs.home-manager.enable = true;
}
