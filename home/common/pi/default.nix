{...}: {
  imports = [./skills.nix];
  home.file.".pi-personal/agent/models.json".source   = ./models.json;
  home.file.".pi-personal/agent/settings.json".source = ./settings.json;
}
