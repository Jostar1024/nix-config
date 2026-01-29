{ config, lib, pkgs, ... }:
let
  # OPENCODE SKILLS MANAGEMENT
  # Skills are git repos pinned to specific commits for reproducibility.
  #
  # ADDING A NEW SKILL:
  #   1. Run: nix run nixpkgs#nix-prefetch-git -- <github-repo-url>
  #   2. Copy "rev" and "sha256" from the JSON output
  #   3. Add new entry to the skills attrset below:
  #      skill-name = pkgs.fetchgit {
  #        url = "https://github.com/user/repo.git";
  #        rev = "<commit-hash>";
  #        sha256 = "<sha256-hash>";
  #      };
  #
  # UPDATING AN EXISTING SKILL:
  #   1. Run: nix run nixpkgs#nix-prefetch-git -- <github-repo-url>
  #   2. Update the "rev" and "sha256" values below
  #   3. Rebuild: home-manager switch (or darwin-rebuild switch)
  #
  # NOTE:
  #   - Skills are stored in /nix/store and symlinked to ~/.config/opencode/skills/
  #   - Current manual skills will be replaced by symlinks after rebuild
  #   - Use short, descriptive names as keys (e.g., "planning-with-files")
  skills = {
    planning-with-files = pkgs.fetchgit {
      url = "https://github.com/OthmanAdi/planning-with-files.git";
      rev = "c1a24568cdf51d0501064fb05b3c70b82cfae4cc";
      sha256 = "0dma31hz7hzfzxbzgmg41lcrvz368kkj87jl996dvy2xls2d6w5h";
    };

    # Add more skills below, for example:
    # elixir-developer = pkgs.fetchgit {
    #   url = "https://github.com/user/elixir-developer-skill.git";
    #   rev = "...";
    #   sha256 = "...";
    # };
  };

  # Convert skills attrset to xdg.configFile entries
  # This creates entries like: xdg.configFile."opencode/skills/skill-name".source = <nix-store-path>;
  skillConfigs = lib.mapAttrs' (name: path: {
    name = "opencode/skills/${name}";
    value.source = path;
  }) skills;

in {
  xdg.configFile = {
    "opencode/opencode.jsonc".source = ./opencode.jsonc;
  } // skillConfigs;
}
