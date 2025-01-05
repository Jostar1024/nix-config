{pkgs, ...}: {
  nix.settings.trusted-users = ["yucheng"];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [vim home-manager];
  # Necessary for using flakes on this system.

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
    brews = [
      "gettext"
      "gh"
      "git"
      "jpeg"
      "libtool"
      "libunistring"
      "m4"
      "pcre2"
      "podman"
      "tailscale"
      "unixodbc"
      "unzip"
    ];

    casks = [
      "aerospace"
      "chromium"
      "firefox"
      "ghostty"
      "logi-options+"
      "raycast"
      "squirrel"
      "tableplus"
      "visual-studio-code"
      "wechat"
    ];
  };

  system.defaults = {
    dock = {autohide = true;};
  };

  security.pam.enableSudoTouchIdAuth = true;
}
