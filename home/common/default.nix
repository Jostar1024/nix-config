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

  home.packages =
    # NOTE: move sioyek to stable because of: https://github.com/NixOS/nixpkgs/issues/366069
    (with pkgs-stable; [emacs-lsp-booster])
    ++ (with pkgs; [
      # ai
      # ollama
      # openai-whisper

      # utils
      gawk
      stow
      curl
      wget
      bat
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
      socat

      # programming
      alejandra
      nil
      asdf-vm
      clj-kondo
      cljfmt
      stylelint
      js-beautify
      prettier
      shellcheck
      rustup
      dockfmt
      shfmt
      nixfmt
      pandoc
      texliveFull
      buf
      (clojure.override {jdk = pkgs.jdk25;})
      babashka
      janet
      jpm
      bun
      mermaid-cli
      neovim
      guile
      autoconf
      automake
      scrcpy
      go-grip
      gdb
      global
      devenv

      podman-compose
      # erlang deps
      fop
      jdk25
      wxwidgets_3_2
      unixodbc
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
      localsend

      # fonts
      jetbrains-mono
      cascadia-code
      fira-code
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      noto-fonts-cjk-sans

      lxgw-wenkai

      # for JP sentence mining.
      mpv
      ffmpeg
    ]);
}
