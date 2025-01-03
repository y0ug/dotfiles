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
  

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
    let
      # user = "rick";
      # user = import ./user.nix;
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      #nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations = {

        rick = inputs.home-manager.lib.homeManagerConfiguration {
          #   # Specify the host architecture
          inherit pkgs;
          #
          #   # Specify your home configuration modules here, for example,
          #   # the path to your home.nix.
          modules = [ ./home.nix ];
          #
          #   extraSpecialArgs = { inherit inputs; };
        };
      };
      nixosConfigurations = {
        rick = nixpkgs.lib.nixosSystem {
          inherit system;
          # specialArgs = attrs // { pkgs = pkgs };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.users.root = import ./home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };
      # formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
}
    );
}
