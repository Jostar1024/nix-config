{
  config,
  lib,
  pkgs,
  ...
}: let
  thumbsCopy =
    if pkgs.lib.strings.hasSuffix "darwin" pkgs.stdenv.hostPlatform.system
    then "set -g @thumbs-command 'echo -n {} | pbcopy'"
    else "";
  catppuccinTmux = pkgs.tmuxPlugins.catppuccin.overrideAttrs (old: {
    version = "2.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v2.3.0";
      hash = "sha256-3CJRQCgS8NAN7vOLBjNGiHbGXTIrIyY/FLmfZrXcEYc=";
    };
  });
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 30000;
    customPaneNavigationAndResize = true;
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = catppuccinTmux;
        # extraConfig runs BEFORE home-manager's auto run-shell.
        # All options set here persist because the plugin uses -ogq (won't override existing).
        extraConfig = ''
          set -g @catppuccin_flavor "latte"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_window_text "#W"

          # status on the right
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_status_left_separator ""

          set -g @catppuccin_session_icon ""
          set -g @catppuccin_session_text "[#S]"

          set -g @catppuccin_directory_icon ""
          set -g @catppuccin_directory_text "[#{s|#{HOME}|~|:pane_current_path}]"
        '';
      }
      tmux-thumbs
      fuzzback
    ];

    prefix = "C-s";
    mouse = true;
    extraConfig = ''
      unbind r
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

      # https://www.reddit.com/r/tmux/comments/sv6skh/clickable_urls/
      bind-key i run-shell -b "tmux capture-pane -J -p | grep -oE '(https?):\/\/.*[^>]' | sort -ui | fzf-tmux -p '80%' --reverse --prompt \"URL> \" | xargs open"

      # this is to solve the warning from pi-coding-agent.
      set -g extended-keys on
      # seems that csi-u is the newest protocol, I'll try it until sth is breaked.
      set -g extended-keys-format csi-u

      set -g @fuzzback-popup 1
      set -g @fuzzback-hide-preview 1
      set -g @fuzzback-popup-size '90%'

      ${thumbsCopy}

      # remain in copy mode
      set -g @yank_action 'copy-pipe'
      set -g @yank_with_mouse on

      set-option -g status-position top

      # Status line (after catppuccin loads, so module variables are available)
      set -g status-left ""
      set -g status-right-length 100
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_session}"
    '';
  };
}
