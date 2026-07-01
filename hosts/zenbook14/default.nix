{ pkgs, ... }:
{
  imports = [
    ../../nix_modules/system.nix
    ../../nix_modules/hyprland.nix
    ../../nix_modules/syncthing.nix
    ../../nix_modules/bluetooth.nix
    ../../nix_modules/vpn.nix

    ../../nix_modules/laptop_power.nix
    ./hardware-configuration.nix
  ];

  services.asusd.enable = true;

  networking.hostName = "zenbook14";
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
}
