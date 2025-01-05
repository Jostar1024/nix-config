{...}: {
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
    };
  };
}
