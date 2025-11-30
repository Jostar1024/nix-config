{...}: {
  programs = {
    ssh = {
      # programs.ssh.enableDefaultConfig is going to be deprecated
      # copy the config to keep the previous behavior
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      enableDefaultConfig = false;

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
