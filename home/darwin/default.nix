{
  pkgs,
  mylib,
  ...
}: {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    # https://github.com/djgoku/dot-files/pull/61/files
    ((pkgs.emacs.override {}).overrideAttrs (old: {
      configureFlags = (old.configureFlags or []) ++ ["--with-no-frame-refocus"];
      NIX_CFLAGS_COMPILE =
        (old.env.NIX_CFLAGS_COMPILE or "")
        + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin
        " -DFD_SETSIZE=10000 -DDARWIN_UNLIMITED_SELECT";
    }))
    iterm2
    iproute2mac
    raycast
    stats

    # postgres
    postgresql_16
    pgformatter
  ];

  programs.home-manager.enable = true;
}
