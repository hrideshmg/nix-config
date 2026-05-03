{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-pkg = {
      url = "./nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcmojave-hyprcursor.url = "github:libadoxon/mcmojave-hyprcursor";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvim-pkg,
      ...
    }@inputs:
    let
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit secrets;
            };
            home-manager.users.hridesh = import ./home.nix;
          }
        ];
      };
    };
}
