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
  services.cloudflared = {
    enable = true;
    tunnels."bc5677ad-b475-475d-bb6e-e7de0313e4ed" = {
      credentialsFile = "/home/hridesh/.cloudflared/bc5677ad-b475-475d-bb6e-e7de0313e4ed.json";
      default = "http_status:404";
      ingress."tal.hrideshmg.com" = "http://localhost:4111";
      ingress."gv.hrideshmg.com" = "http://localhost:8000";
    };
  };
}
