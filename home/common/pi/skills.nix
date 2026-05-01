{pkgs, ...}: let
  # Fetch the entire repo into the nix store
  mattpocock-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "b843cb5ea74b1fe5e58a0fc23cddef9e66076fb8"; # pin to a commit hash for reproducibility
    hash = "sha256-qOhU5bBnT6kI8c7i0r0IyecrgLJNNPlmQtAb6qWM73Q=";
  };

  # Pick the skills you want
  engineeringSkills = [
    "diagnose"
    "grill-with-docs"
    "triage"
    "improve-codebase-architecture"
    "setup-matt-pocock-skills"
    "tdd"
    "to-issues"
    "to-prd"
    "zoom-out"
  ];

  # Link each to ~/.agents/skills/<name>/
  mkSkill = name: {
    name = ".agents/skills/${name}";
    value.source = "${mattpocock-skills}/skills/engineering/${name}";
  };
in {
  home.file = builtins.listToAttrs (map mkSkill engineeringSkills);
}
