{pkgs, ...}: {
  home.packages = [pkgs.git-cliff];

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".projectile"
    ];
    settings = {
      user.email = "howard.eureka@gmail.com";
      user.name = "Yucheng CAO";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;

      alias = {
        # common aliases
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        dc = "diff --cached";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {features = "side-by-side";};
  };
}
