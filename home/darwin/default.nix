{
  pkgs,
  mylib,
  ...
}: {
  imports = (mylib.scanPaths ./.) ++ [../common] ++ [../programs/ssh.nix];

  home.username = "yucheng";
  home.homeDirectory = "/Users/yucheng";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    # https://github.com/djgoku/dot-files/pull/61/files
    ((pkgs.emacs.override {}).overrideAttrs (old: {
      NIX_CFLAGS_COMPILE =
        (old.env.NIX_CFLAGS_COMPILE or "")
        + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin
        " -DFD_SETSIZE=10000 -DDARWIN_UNLIMITED_SELECT";
    }))
    iterm2
    iproute2mac
    raycast
    stats

    alist

    # postgres
    postgresql_16
    pgformatter
  ];

  programs.home-manager.enable = true;
}
