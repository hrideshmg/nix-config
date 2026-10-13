{ pkgs, lib, ... }:
let
  # NOTE: state lives in a file under XDG_RUNTIME_DIR (cleared on reboot, which
  # matches Hyprland resetting the device to enabled). If you toggle the device
  # by other means, the widget will drift out of sync.
  keyboardToggle = pkgs.writeShellScript "keyboard-toggle" ''
    state="''${XDG_RUNTIME_DIR:-/tmp}/laptop-keyboard-disabled"

    if [ "$1" = "toggle" ]; then
      if [ -e "$state" ]; then
        hyprctl eval "hl.device({name='at-translated-set-2-keyboard', enabled=true})" && rm -f "$state"
      else
        hyprctl eval "hl.device({name='at-translated-set-2-keyboard', enabled=false})" && touch "$state"
      fi
      pkill -RTMIN+9 waybar
      exit 0
    fi

    if [ -e "$state" ]; then
      echo '{"text": "󰌐", "tooltip": "Laptop keyboard disabled", "class": "disabled"}'
    else
      echo '{"text": "󰌌", "tooltip": "Laptop keyboard enabled", "class": "enabled"}'
    fi
  '';
in
{
  home.packages = with pkgs; [
    wlsunset
    brightnessctl
  ];

  programs.waybar.settings.mainBar = {
    modules-left = [
      #"custom/power_profile"
    ];

    modules-right = lib.mkForce [
      "tray"
      "custom/keyboard"
      "backlight"
      "pulseaudio"
      "network"
      "battery"
      "clock"
    ];

    #"custom/power_profile" = {
    #  format = "{}";
    #  exec = "~/.config/waybar/scripts/power_profile.sh";
    #  return-type = "json";
    #  on-click = "~/.config/waybar/scripts/power_profile.sh next && pkill -RTMIN+8 waybar";
    #  signal = 8;
    #  interval = "once";
    #  tooltip = true;
    #};

    "custom/keyboard" = {
      exec = "${keyboardToggle}";
      return-type = "json";
      on-click = "${keyboardToggle} toggle";
      signal = 9;
      interval = "once";
    };

    backlight = {
      format = "{icon} {percent}%";
      format-icons = [
        ""
        ""
        ""
        ""
      ];
      on-click = "pkill -USR1 wlsunset";
      on-scroll-up = "brightnessctl set +2%";
      on-scroll-down = "brightnessctl --min-value=2 set 2%-";
    };

    battery = {
      interval = 5;
      states = {
        warning = 30;
        critical = 15;
      };
      max-length = 20;
      format = "{icon} {capacity}%";
      format-charging = "<span font-family='Font Awesome 6 Free'></span> {capacity}%";
      format-plugged = "  {capacity}%";
      format-alt = "{icon} {time}";
      format-full = "  {capacity}%";
      format-icons = [
        " "
        " "
        " "
        " "
        " "
      ];
    };
  };
}
