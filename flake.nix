{
  description = "Yucheng's nixos config";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    extra-substituters = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org/";
    trusted-substituters = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org/";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # NOTE: how to use both stable & unstable
    # https://www.reddit.com/r/NixOS/comments/15zd11c/using_both_2305_unstable_in_homemanager/
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    linyinfeng.url = "github:linyinfeng/nur-packages";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    linyinfeng
  }: let
    # pkgs-stable-func = system: nixpkgs-stable.legacyPackages."${system}";
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

    homeConfigurations."yuchengcao" = let
      pkgs-stable = nixpkgs-stable.legacyPackages.aarch64-darwin;
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./home/darwin.nix
          ./home/common.nix
        ];
        extraSpecialArgs = {inherit pkgs-stable;};
      };

    homeConfigurations."yucheng" = let
      pkgs-stable = nixpkgs-stable.legacyPackages.aarch64-darwin;
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./home/darwin2.nix
          ./home/common.nix
        ];
        extraSpecialArgs = {inherit pkgs-stable;};
      };
  };
}
