{
  pkgs,
  config,
  lib,
  secrets,
  ...
}:
let
  vpncmd = "${config.services.softether.dataDir}/vpncmd/vpncmd";

  serverIP = secrets.softether.server_ip;
  serverPort = secrets.softether.server_port;
  accountName = secrets.softether.account_name;
  hub = secrets.softether.hub;
  vpnUser = secrets.softether.username;
  vpnPassword = secrets.softether.password;
in
{
  services.softether = {
    enable = true;
    vpnclient.enable = true;
  };

  # Required for DNS resolution when DHCP is running
  services.resolved.enable = true;

  systemd.services.vpnclient.serviceConfig = {
    ExecStart = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient start";
    ExecStop = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient stop";
  };

  systemd.services.vpnclient-account-setup = {
    description = "Provision SoftEther VPN client account";
    after = [ "vpnclient.service" ];
    requires = [ "vpnclient.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -eu
      if ! ${vpncmd} localhost /client /cmd AccountList | grep -q "${accountName}"; then
        ${vpncmd} localhost /client /cmd AccountCreate ${accountName} \
          /SERVER:${serverIP}:${serverPort} /HUB:${hub} /USERNAME:${vpnUser} /NICNAME:softether
      fi

      ${vpncmd} localhost /client /cmd AccountPasswordSet ${accountName} \
        /PASSWORD:"${vpnPassword}" /TYPE:standard
    '';
  };

  networking.networkmanager = {

    ensureProfiles.profiles = {
      "vpn_on" = {
        connection = {
          id = "vpn_on";
          type = "dummy";
          interface-name = "vpn_on";
          autoconnect = "false";
        };
      };
    };

    dispatcherScripts = [
      {
        source = pkgs.writeText "upHook" ''
          INTERFACE=$1
          ACTION=$2
          ACCOUNT_NAME="${accountName}"
          TARGET_IP="${serverIP}/32"
          VPN_GATEWAY="192.168.30.1"    # Default gateway for softether virtual hubs
          VPN_INTERFACE="vpn_softether" # NIC created by softether

          if [[ "$INTERFACE" == "vpn_on" ]]; then  # vpn_on refers to the dummy nmcli connection
          case "$ACTION" in
          up)
              if ip route show default via "$VPN_GATEWAY" | grep -q .; then
          	    echo "Deactivating VPN.."
          	    /var/lib/softether/vpncmd/vpncmd localhost /client /cmd AccountDisconnect "$ACCOUNT_NAME"
                    ${pkgs.dhcpcd}/bin/dhcpcd -k "$VPN_INTERFACE"

          	    echo "Deleting Routes.."
          	    ip route del "$TARGET_IP"
              else
          	default_gateway=$(ip route show default | ${pkgs.gawk}/bin/awk '{print $3}')
          	if [ -z "$default_gateway" ]; then
          	    echo "Error: Could not find default gateway."
          	    exit 1
          	fi

          	echo "Activating VPN Connection.."
          	/var/lib/softether/vpncmd/vpncmd localhost /client /cmd AccountConnect "$ACCOUNT_NAME"

          	echo "Requesting IP for VPN via DHCP..."
                ${pkgs.dhcpcd}/bin/dhcpcd -GO 121 "$VPN_INTERFACE" # -GO 121 disables route creation as we will make them ourselves

          	echo "Adding exception route for VPN server through local gateway..."
                ip route add "$TARGET_IP" via "$default_gateway" # Required to avoid a routing loop

          	echo "Adding route for tunneling all traffic through VPN gateway..."
          	ip route add default via "$VPN_GATEWAY" dev "$VPN_INTERFACE" metric 10
              fi
          ;;
          esac
          fi
        '';
        type = "basic";
      }
    ];
  };
}
