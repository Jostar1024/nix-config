{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [zsh-fzf-tab];
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = ["history" "completion" "match_prev_cmd"];
    };
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit
      if [[ -n ${config.xdg.configHome}/zsh/.zcompdump(#qNmh-24) ]]; then
        compinit -C -d ${config.xdg.configHome}/zsh/.zcompdump
      else
        compinit -d ${config.xdg.configHome}/zsh/.zcompdump
      fi
    '';
    history = {
      ignoreDups = true;
      saveNoDups = true;
      extended = false;
      ignoreSpace = true;
      ignorePatterns = ["rm *" "pkill *"];
    };
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

    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 "zstyle ':omz:plugins:nvm' lazy yes";
      zshConfig =
        lib.mkOrder
        1000
        ''
          # export LANG=en_US.UTF-8
          # for doom emacs commands
          export PATH=$PATH:~/.config/emacs/bin
          # NOTE: use homebrew ruby in zsh
          export PATH=$PATH:$HOMEBREW_PREFIX/lib/ruby/gems/4.0.0/bin
          export PATH=$PATH:/opt/homebrew/opt/ruby/bin
          # NOTE: dart related
          export PATH=$PATH:"$HOME/.pub-cache/bin"
          export PATH=$PATH:~/.local/bin
          export PATH=$PATH:$HOME/.asdf/shims
          export PATH=$PATH:$HOME/.cargo/bin

          # -X leaves file contents on the screen when less exits.
          # -F makes less quit if the entire output can be displayed on one screen.
          # -R displays ANSI color escape sequences in "raw" form.
          # -S disables line wrapping. Side-scroll to see long lines.
          export LESS="-SRXF"

          # NOTE: from https://mijndertstuij.nl/posts/life-is-too-short-for-a-slow-terminal/
          export NVM_DIR="$HOME/.nvm"
          nvm() {
            unset -f nvm
            [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use
            [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
            nvm "$@"
          }

          # append completions to fpath
          fpath=(${pkgs.asdf-vm}/share/zsh/site-functions/ $fpath)

          # Show process using a port
          port() {
            lsof -i :"$1"
          }
          # Get PID using a port
          pidport() {
            lsof -ti :"$1"
          }
          # Gracefully kill process on a port
          killport() {
            kill $(lsof -ti :"$1")
          }
          # Force kill process on a port
          killport9() {
            kill -9 $(lsof -ti :"$1")
          }

          [ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"
          [ -f "$HOME/.env" ] && source "$HOME/.env"

          backup_mv() { mv -- "$1" "$(date +%Y%m%d_%H%M%S)_$1"; }

        '';
      zshLast = lib.mkOrder 1500 ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        # NOTE: this requires the compinit, which is configured in oh-my-zsh's script
        # use this to ensure that zoxide init zsh runs after the compinit
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

        # OSC 133 - Semantic Prompt Shell Integration
        #
        # Marks terminal regions so Ghostty/tmux can jump between prompts:
        #   A = start of prompt, B = end of prompt (start of input)
        #   C = start of command output, D = end of command output
        #
        # Starship integration:
        #   Starship rewrites PROMPT on every precmd via prompt_starship_precmd.
        #   A and B marks must be embedded IN the PROMPT string (not printf'd separately)
        #   because starship's multi-line prompt rendering displaces standalone marks.
        #   _osc133_set_prompt_marks runs AFTER starship in precmd_functions to wrap
        #   the final PROMPT with A (prepend) and B (append).
        #
        # Hook ordering (precmd_functions):
        #   1. _osc133_precmd        - emit D mark (end of previous output)
        #   2. prompt_starship_precmd - starship sets PROMPT
        #   3. _osc133_set_prompt_marks - wrap PROMPT with A and B marks
        #
        _osc133_executing=""
        function _osc133_precmd() {
          local ret=$?
          if [[ -n "$_osc133_executing" ]]; then
            printf '\e]133;D;%d\a' "$ret"
          fi
          _osc133_executing=""
        }
        function _osc133_preexec() {
          printf '\e]133;C\a'
          _osc133_executing=1
        }
        function _osc133_set_prompt_marks() {
          PROMPT="%{$(printf '\e]133;A\a')%}$PROMPT%{$(printf '\e]133;B\a')%}"
        }
        precmd_functions=(_osc133_precmd "''${precmd_functions[@]}")
        precmd_functions+=(_osc133_set_prompt_marks)
        preexec_functions+=(_osc133_preexec)
      '';
    in
      lib.mkMerge [zshConfigEarlyInit zshConfig zshLast];
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    envExtra = ''
      # Emacs M-x compile use non-login, non-interactive shell, which only inlcudes .zshenv
      # To use command from homebrew, have to add homebrew to path
      # - NOTE ~/.zshenv (the only zsh config file sourced for non-login, non-interactive shells):
      path+=('/opt/homebrew/bin' '/opt/homebrew/sbin')
    '';

    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;
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
    # works on MacOS
    ports = "lsof -i -P -n | grep LISTEN";
  };
}
