deploy:
  nixos-rebuild switch --use-remote-sudo --flake .

deploy-mac-home:
  home-manager switch --flake ~/nix-config
