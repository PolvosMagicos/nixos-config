{
  description = "Flake for my legion 5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs ... }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
	      ./hardware-configuration.nix
      ];
    };
  };
}
