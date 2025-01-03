{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, flake-utils, ... }:
    let
      eachSystem = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          nixosConfigurations = {
            rick = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.rick = import ./home.nix;
                }
              ];
            };
          };
        }
      );
    in
    eachSystem // {
      homeConfigurations = {
        rick = home-manager.lib.homeManagerConfiguration {
          inherit (eachSystem.x86_64-linux) pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}

