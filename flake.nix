{
  description = "Flake for my legion 5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, niri,  ... }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	      ./hardware-configuration.nix
	      # lanzaboote.nixosModules.lanzaboote

	      # Niri
	      # niri.nixosModules.niri

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
