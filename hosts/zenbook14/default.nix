{ ... }:
{
  imports = [
    ../../nix_modules/system.nix
    ../../nix_modules/hyprland.nix
    ../../nix_modules/syncthing.nix
    ../../nix_modules/bluetooth.nix

    ./hardware-configuration.nix
  ];
  networking.hostName = "zenbook14";
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
}
