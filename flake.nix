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
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvim-pkg,
      claude-code,
      ...
    }@inputs:
    let
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
      hostArgs.workstation.monitors = import ./hosts/workstation/monitors.nix;
      hostArgs.zenbook14.monitors = import ./hosts/zenbook14/monitors.nix;
    in
    {
      nixosConfigurations.workstation =
        let
          username = "operator";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit username;
            inherit secrets;
          };
          modules = [
            ./hosts/workstation

            { nixpkgs.overlays = [ claude-code.overlays.default ]; }

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
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

      nixosConfigurations.zenbook14 =
        let
          username = "hridesh";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit username;
            inherit secrets;
          };
          modules = [
            ./hosts/zenbook14

            { nixpkgs.overlays = [ claude-code.overlays.default ]; }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit secrets;
                inherit username;
              }
              // hostArgs.zenbook14; # merge this attr set into the above
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
    };
}
