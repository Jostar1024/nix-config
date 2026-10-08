{config, ...}: {
  # karabiner-elements is installed via homebrew cask
  home.file.".config/karabiner/karabiner.json" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/home/karabiner/karabiner.json";
    # the target is a plain file written by the Karabiner GUI before this was managed
    force = true;
  };
}
