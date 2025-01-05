{pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [vim home-manager];
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    brews = [
      "gettext"
      "gh"
      "git"
      # "jordanbaird-ice"
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
}
