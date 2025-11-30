{
  config,
  lib,
  pkgs,
  ...
}: let
  font = "FiraCode Nerd Font Mono";
  decoration =
    if pkgs.lib.strings.hasSuffix "darwin" pkgs.system
    then "buttonless"
    else "none";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = ["${pkgs.alacritty-theme}/share/alacritty-theme/tokyo_night.toml"];
      env = {
        TERM = "xterm-256color";
      };
      terminal.shell.program = "zsh";
      # terminal = {shell.program = "zsh";};
      window = {
        padding.x = 14;
        padding.y = 14;
        decorations = decoration;
        opacity = 0.95;
        dimensions = {
          lines = 80;
          columns = 200;
        };
      };
      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
      ];
      font = {
        size = 14;
        normal = {
          family = font;
          style = "Retina";
        };
        bold = {
          family = font;
          style = "Bold";
        };
        italic = {
          family = font;
          style = "Italic";
        };
      };
    };
  };
}
