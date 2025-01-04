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
      # pkgs = import nixpkgs {
      #   inherit system;
      #   config = {
      #     allowUnfree = true;
      #   };
      # };
      # getHomeConfig = system: name: outputs.legacyPackages.${system}.homeConfigurations;
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
      # inherit system;
      # packages.${system}.homeConfigurations.rick = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [ ./home.nix ];
      #     extraSpecialArgs = { inherit inputs; };
      # };
    #   homeConfigurations.rick = inputs.home-manager.lib.homeManagerConfiguration {
    #       modules = [ ./home.nix ];
    #       # extraSpecialArgs = { inherit inputs; };
    #       pkgs = import nixpkgs {
    #         system = "x86_64-linux";
    #         config = {
    #           allowUnfree = true;
    #         };
    #     };
    # };
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

