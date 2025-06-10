{
  description = "Yucheng's nixos config";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    trusted-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # NOTE: how to use both stable & unstable
    # https://www.reddit.com/r/NixOS/comments/15zd11c/using_both_2305_unstable_in_homemanager/
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    linyinfeng.url = "github:linyinfeng/nur-packages";

    # nix-darwin's config
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    linyinfeng,
    nixpkgs-darwin,
    nix-darwin,
  } @ inputs: let
    inherit (inputs.nixpkgs) lib;
    mylib = import ./lib {inherit lib;};
    pkgs-stable-func = system: nixpkgs-stable.legacyPackages."${system}";
    pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
  in {
    nixosConfigurations = {
      blade-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/blade-desktop
          ({pkgs, ...}: {
            nixpkgs.overlays = [linyinfeng.overlays.singleRepoNur];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yucheng = import ./home;
            home-manager.extraSpecialArgs = {inherit pkgs-stable;};
          }
        ];
      };
    };

    homeConfigurations."yuchengcao" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./home/darwin.nix
        ./home/common
      ];
      extraSpecialArgs = {
        pkgs-stable = pkgs-stable-func "aarch64-darwin";
        inherit mylib;
      };
    };

    darwinConfigurations."set-theoretic-untyped" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./modules/darwin/nix-core.nix
        ./modules/darwin/system.nix
        ./modules/darwin/apps.nix
        ./modules/darwin/homebrew-mirror.nix
        ./hosts/darwin.nix
        home-manager.darwinModules.home-manager
        {
          # https://github.com/nix-community/home-manager/issues/6036
          users.users.yucheng.home = "/Users/yucheng";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yucheng = import ./home/darwin;
          home-manager.extraSpecialArgs = {
            pkgs-stable = pkgs-stable-func "aarch64-darwin";
            inherit mylib;
          };
        }
      ];
    };
  };
}
