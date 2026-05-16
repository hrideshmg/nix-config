{
  config,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ../../nix_modules/system.nix
    ../../nix_modules/hyprland.nix
    ../../nix_modules/syncthing.nix

    ./hardware-configuration.nix
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

  networking.firewall.allowedTCPPorts = [
    8443
    5900
  ];

  systemd.services.websockify = {
    enable = true;
    description = "websockify (no TLS)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.python313Packages.websockify}/bin/websockify --cert=${../../secrets/hrideshmg.com/cert.pem} --key=${../../secrets/hrideshmg.com/key.pem} --web=${pkgs.novnc}/share/webapps/novnc 0.0.0.0:8443 127.0.0.1:5900";
      Restart = "on-failure";
    };
  };

  services.openssh.enable = true;
  services.qemuGuest.enable = true;
}
