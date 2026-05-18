{ ... }:
{
  imports = [
    ../../nix_modules/system.nix
    ../../nix_modules/hyprland.nix
    ../../nix_modules/syncthing.nix

    ./hardware-configuration.nix
  ];
  networking.hostName = "zenbook14";
}
