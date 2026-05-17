{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wlsunset
  ];

  imports = [
    ./default.nix
  ];

  modules-left = [
    #"custom/power_profile"
    "cpu"
    "memory"
    "hyprland/workspaces"
  ];

  modules-right = [
    "tray"
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

  backlight = {
    format = "{icon} {percent}%";
    format-icons = [
      ""
      ""
      ""
      ""
    ];
    on-click = "pkill -USR1 wlsunset";
    on-scroll-up = "brightnessctl -d intel_backlight set +2%";
    on-scroll-down = "brightnessctl --min-value -d intel_backlight set 2%-";
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

}
