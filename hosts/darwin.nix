{...}: {
  nix.settings.trusted-users = ["yucheng"];
  # Necessary for using flakes on this system.

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  nixpkgs.config.allowUnfree = true;
  # NOTE: for the sake of pgpem 1.24 error when using keepass
  nixpkgs.config.allowBroken = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
