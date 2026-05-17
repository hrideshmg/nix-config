{ pkgs, ... }:
{
  # couples with `services.wayvnc` in the users home.nix
  systemd.services.websockify = {
    enable = true;
    description = "websockify (no TLS)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.python313Packages.websockify}/bin/websockify --cert=${../secrets/hrideshmg.com/cert.pem} --key=${../secrets/hrideshmg.com/key.pem} --web=${pkgs.novnc}/share/webapps/novnc 0.0.0.0:8443 127.0.0.1:5900";
      Restart = "on-failure";
    };
  };
}
