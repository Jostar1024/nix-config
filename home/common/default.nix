{
  pkgs,
  pkgs-stable,
  mylib,
  ...
}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../programs/tmux.nix
      ../programs/zsh.nix
      ../programs/alacritty.nix
      ../programs/git.nix
      ../programs/shell.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home.packages =
    # NOTE: move sioyek to stable because of: https://github.com/NixOS/nixpkgs/issues/366069
    (with pkgs-stable; [emacs-lsp-booster elixir-ls])
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
      oils-for-unix

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
      clojure
      janet
      jpm
      nodejs_23
      mermaid-cli
      neovim

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
      # sioyek

      # fonts
      jetbrains-mono
      cascadia-code
      fira-code
      (pkgs.nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "CascadiaCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
      lxgw-wenkai
    ]);
}
