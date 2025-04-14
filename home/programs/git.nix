{pkgs, ...}: {
  home.packages = [pkgs.git-cliff];

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".projectile"
    ];
    userEmail = "howard.eureka@gmail.com";
    userName = "Yucheng CAO";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
    delta = {
      enable = true;
      options = {
        features = "side-by-side";
      };
    };
    aliases = {
      # common aliases
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      dc = "diff --cached";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };
}
