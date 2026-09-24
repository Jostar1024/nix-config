{
  config,
  ...
}: {
  imports = [
    ./skills.nix
    ./extensions.nix
  ];

  home.file.".pi/agent/APPEND_SYSTEM.md".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/home/common/pi/APPEND_SYSTEM.common.md";

  home.file.".pi-personal/APPEND_SYSTEM.md".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/home/common/pi/APPEND_SYSTEM.common.md";
}
