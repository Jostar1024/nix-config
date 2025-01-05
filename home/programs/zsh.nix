{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history.ignoreDups = true;
    sessionVariables = {
      EDITOR = "emacs";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    localVariables = {
      KERL_BUILD_DOCS = "yes";
      KERL_INSTALL_MANPAGES = "yes";
      KERL_INSTALL_HTMLDOCS = "yes";
    };
    initExtra = ''
      # export LANG=en_US.UTF-8
      export PATH=$PATH:~/.config/emacs/bin

      # -X leaves file contents on the screen when less exits.
      # -F makes less quit if the entire output can be displayed on one screen.
      # -R displays ANSI color escape sequences in "raw" form.
      # -S disables line wrapping. Side-scroll to see long lines.
      export LESS="-SRXF"
      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      source ~/.zshrc

      eval "$(starship init zsh)"
      . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
      . "${pkgs.asdf-vm}/share/bash-completion/completions/asdf.bash"
    '';
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    dotDir = ".config/zsh";
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "sudo"];
    };
  };

  home.shellAliases = {
    ls = "eza";
    l = "eza -lh";
    la = "eza -la";
    hms = "just -f ~/nix-config/justfile deploy-mac-home";
    switch = "just -f ~/nix-config/justfile deploy-mac";
    tn = "tmux new-session -A -s";
    ta = "tmux attach -t";
    k = "kubectl";
    cat = "bat --style=plain --pager=never";
    fonts = "fc-list | awk -F: '{print $2}' | sort | uniq";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
