{
  description = "Flake for my legion 5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager ... }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
	      ./hardware-configuration.nix

	      #Home manager config
	      home-manager.nixosModules.default
	      {
	        home-manager = {
            useGlobalPkgs = true;
	          useUserPackages = true;
	          backupFileExtension = "backup";
	          users.polvos-magicos = ./home.nix;
	        };
	      }
      ];
    };
  };
}
