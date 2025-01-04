{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    homeConfigurations = {
      linux64-rick = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {}; # allowUnfree = true; };
          };
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };

      osx-rick = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {}; # allowUnfree = true; };
        };
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
  };
}

