{...}: {
  #  All the configuration options are documented here: https://daiderd.com/nix-darwin/manual/index.html#sec-options
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
      dock = {
        autohide = true;
        show-recents = false; # disable recent apps

        # customize Hot Corners
        # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-bl-corner
        wvous-tl-corner = 2;
        wvous-bl-corner = 11; # Launchpad
        wvous-tr-corner = 1; # Disabled
        wvous-br-corner = 1; # Disabled

        # NOTE: for aerospace to expose the bigger application window.
        # see: https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
        expose-group-apps = true;
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };
      trackpad = {
        Clicking = true; # enable tap to click
        TrackpadRightClick = true; # enable two finger right click
      };

      # customize settings that not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        # `defaults read NSGlobalDomain "xxx"`
        "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
        "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key
        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        ApplePressAndHoldEnabled = true; # enable press and hold

        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 2; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

        # NSAutomaticCapitalizationEnabled = false; # disable auto capitalization(自动大写)
        # NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution(智能破折号替换)
        # NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution(智能句号替换)
        # NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution(智能引号替换)
        # NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction(自动拼写检查)
        # NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default(保存文件时的路径选择/文件名输入页)
        # NSNavPanelExpandedStateForSaveMode2 = true;
      };

      # https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
      # settings not directly supported by nix-darwin
      # CustomUserPreferences = {...}
      CustomUserPreferences = {
        # https://github.com/LnL7/nix-darwin/issues/185
        # https://github.com/ConstantinCezarBegu/nix/blob/4c86003720e0591891924e5a8d7e05a3519e5911/module/darwin/macos-keyboard-shortcuts-configuration.nix
        # https://apple.stackexchange.com/questions/474904/what-does-each-part-in-com-apple-symbolichotkeys-plist-mean
        # https://github.com/NUIKit/CGSInternal/blob/master/CGSHotKeys.h
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Open spotlight
            "64" = {enabled = false;};
          };
        };
      };
    };
    keyboard = {
      enableKeyMapping = true; # enable key mapping so that we can use `option` as `control`

      remapCapsLockToControl = false; # remap caps lock to control, useful for emac users

      # swap left command and left alt
      # so it matches common keyboard layout: `ctrl | command | alt`
      #
      # disabled, caused only problems!
      swapLeftCommandAndLeftAlt = false;
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
}
