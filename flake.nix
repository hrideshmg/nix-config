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
      hostArgs.workstation.monitors = import ./hosts/workstation/monitors.nix;
    in
    {
      nixosConfigurations.workstation =
        let
          username = "operator";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit username; };
          modules = [
            ./hosts/workstation
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit secrets;
                inherit username;
              }
              // hostArgs.workstation; # merge this attr set into the above
              home-manager.users.${username} = {
                imports = [
                  ./home.nix
                  ./users/${username}/home.nix
                ];
              };
            }
          ];
        };
    };
}
