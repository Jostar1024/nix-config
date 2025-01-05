{pkgs, mylib, ...}: {

  imports = (mylib.scanPaths ./.) ++ [../common.nix];

  home.username = "yucheng";
  home.homeDirectory = "/Users/yucheng";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    emacs
    iterm2
    darwin.iproute2mac
    raycast
    stats
    # postgres
    pgcli
    postgresql_16
    pgformatter
  ];

  programs.home-manager.enable = true;
}
