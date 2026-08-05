{
  username,
  pkgs,
  ...
}:

{
  imports = [
    ../../nix_modules/system.nix
    ../../nix_modules/hyprland.nix
    ../../nix_modules/syncthing.nix
    ../../nix_modules/vnc-web.nix

    ./hardware-configuration.nix
  ];

  environment.systemPackages = [
    pkgs.cloudflared
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  networking = {
    hostName = "workstation";
    defaultGateway = "192.168.1.1";
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.1.65";
        prefixLength = 24;
      }
    ];

    networkmanager.enable = true;
  };

  services.greetd.settings = {
    initial_session = {
      command = "start-hyprland";
      user = username;
    };
  };
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
}
