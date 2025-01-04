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
    flake-utils.lib.eachDefaultSystem (system:
    let

    in
    {
      # nixosConfigurations = {
      #   rick = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ./configuration.nix
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.rick = import ./home.nix;
      #       }
      #     ];
      #   };
      # };
      homeConfigurations."rick@linux" = home-manager.lib.homeManagerConfiguration {
          # inherit pkgs system;
          modules = [ ./home.nix ];
          # extraSpecialArgs = { inherit inputs pkgs; };
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };

      homeConfigurations."rick@linux" = home-manager.lib.homeManagerConfiguration {
          # inherit pkgs system;
          modules = [ ./home.nix ];
          # extraSpecialArgs = { inherit inputs pkgs; };
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
          };
        };
    });
}

