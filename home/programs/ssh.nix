{...}: {
  programs = {
    ssh = {
      enable = true;

      extraConfig = ''
      Host *
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519

      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
      '';
    };
  };
}
