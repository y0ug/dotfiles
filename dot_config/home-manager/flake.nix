{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      inherit system;
      ${system}.homeConfigurations = {

        rick = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
      # nixosConfigurations = {
      #   rick = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     # specialArgs = attrs // { pkgs = pkgs };
      #     modules = [
      #       ./configuration.nix
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         # home-manager.users.root = import ./home.nix;
      #
      #         # Optionally, use home-manager.extraSpecialArgs to pass
      #         # arguments to home.nix
      #       }
      #     ];
      #   };
      # };
      # formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    });
}

