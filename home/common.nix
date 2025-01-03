{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    ./programs/tmux.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/alacritty.nix
    ./programs/git.nix
    ./programs/shell.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home.packages =
    (with pkgs-stable; [emacs-lsp-booster eza elixir-ls])
    ++ (with pkgs; [
      # ai
      ollama

      # utils
      stow
      curl
      wget
      neofetch
      bat
      pgcli
      htop
      tree
      flyctl
      visidata
      tealdeer
      ripgrep
      findutils
      fd
      fzf
      jq
      yq-go
      comma
      zellij
      nix-search-cli
      manix
      nix-index
      just
      android-tools
      graphviz
      janet
      jpm

      # programming
      alejandra
      nil
      asdf-vm
      terraform
      clj-kondo
      cljfmt
      stylelint
      nodePackages.js-beautify
      nodePackages.prettier
      shellcheck
      rustup
      rustc
      dockfmt
      shfmt
      nixfmt-classic
      racket
      pandoc
      texliveFull
      haskellPackages.lsp
      haskellPackages.hoogle
      haskellPackages.cabal-install
      buf

      podman-compose
      # erlang deps
      fop
      jdk21
      wxGTK32
      unixODBC
      openssl

      # libs
      librime
      fontconfig
      coreutils
      (aspellWithDicts (dicts: with dicts; [en en-computers en-science fr]))
      # softwares
      alacritty
      syncthing
      keepassxc
      zathura
      sioyek

      # fonts
      jetbrains-mono
      cascadia-code
      fira-code
      (pkgs.nerdfonts.override {fonts = ["FiraCode" "CascadiaCode" "JetBrainsMono"];})
      lxgw-wenkai
    ]);
}
