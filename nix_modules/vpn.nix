{ config, lib, ... }:
{
  services.softether = {
    enable = true;
    vpnclient.enable = true;
  };

  systemd.services.vpnclient.serviceConfig = {
    ExecStart = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient start";
    ExecStop = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient stop";
  };
}
