{ pkgs, monitors, ... }:
let
  monitor = builtins.elemAt monitors 0;

  refresh_switcher = pkgs.writeShellScript "hypr-refresh-switcher" ''
    set_refresh() {
      local ac_online=0

      for supply in /sys/class/power_supply/*/online; do
        if [[ -f "$supply" ]] && grep -q "1" "$supply"; then
          ac_online=1
          break
        fi
      done

      if [[ "$ac_online" == "1" ]]; then
        echo "AC Power: Setting to ${monitor.refresh}Hz."
        ${pkgs.hyprland}/bin/hyprctl keyword monitor "${monitor.name},${monitor.resolution}@${monitor.refresh},auto,${monitor.scaling}"
        sleep 3
      else
        echo "Battery Power: Setting to 60Hz."
        ${pkgs.hyprland}/bin/hyprctl keyword monitor "${monitor.name},${monitor.resolution}@60,auto,${monitor.scaling}"
        sleep 3
      fi
    }

    set_refresh

    # udevadm monitor is a blocking call
    ${pkgs.systemd}/bin/udevadm monitor --subsystem-match=power_supply | while read -r line; do
      set_refresh
    done
  '';
in
{
  systemd.user.services.hypr-refresh-switcher = {
    Unit = {
      Description = "Dynamic Hyprland Refresh Rate Switcher";
      # Tie this to the hyprland session so it automatically starts and stops with your WM
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${refresh_switcher}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
