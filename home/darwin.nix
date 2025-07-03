{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./darwin/aerospace];
  home.username = "yuchengcao";
  home.homeDirectory = "/Users/yuchengcao";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    ((pkgs.emacs.override {}).overrideAttrs (old: {
      NIX_CFLAGS_COMPILE =
        (old.env.NIX_CFLAGS_COMPILE or "")
        + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin
        " -DFD_SETSIZE=10000 -DDARWIN_UNLIMITED_SELECT";
    }))
    iterm2
    iproute2mac
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
