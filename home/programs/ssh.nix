{...}: {
  programs = {
    ssh = {
      enable = true;

      extraConfig = ''
        Host *
          UseKeychain yes
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_ed25519
      '';
    };
  };
}
