{ config, lib, pkgs, ... }:

{
  xdg.configFile."opencode/opencode.jsonc".source = ./opencode.jsonc;
}
