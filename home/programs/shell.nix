{
  config,
  pkgs,
  ...
}: {
  programs.less = {
    enable = true;
    keys = "
      h left-scroll
      l right-scroll
    ";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
