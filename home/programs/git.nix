{...}: {
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".projectile"
    ];
    userEmail = "howard.eureka@gmail.com";
    userName = "Yucheng CAO";
  };
}
