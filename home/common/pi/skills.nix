{pkgs, ...}: let
  # --- mattpocock/skills (pinned to commit) ---
  mattpocock-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "ed37663cc5fbef691ddfecd080dff42f7e7e350d";
    hash = "sha256-o/H9s3t6ahBqFwpkOMBOTwpsvb33pgvpI9n0PA+uLYM=";
  };

  engineeringSkills = [
    "code-review"
    "codebase-design"
    "diagnosing-bugs"
    "grill-with-docs"
    "implement"
    "prototype"
    "research"
    "resolving-merge-conflicts"
    "tdd"
    "to-spec"
    "to-tickets"
    "triage"
    "wayfinder"
  ];

  mkMattSkill = name: {
    name = ".agents/skills/${name}";
    value.source = "${mattpocock-skills}/skills/engineering/${name}";
  };

  # --- Personal skills (stored in this repo) ---
  personalSkills = ["elixir-developer"];

  mkPersonalSkill = name: {
    name = ".agents/skills/${name}";
    value.source = ./skills/${name};
  };
in {
  home.file =
    builtins.listToAttrs (map mkMattSkill engineeringSkills)
    // builtins.listToAttrs (map mkPersonalSkill personalSkills);
}
