{ pkgs, ... }:
{

  home.packages = with pkgs; [
    font-awesome
  ];

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;

    settings = {
      mainBar = {
        # "height" = 40;
        layer = "top";
        margin-top = 0;
        margin-left = 0;
        margin-bottom = 0;
        margin-right = 0;
        spacing = 5;

        modules-left = [
          "cpu"
          "memory"
          "hyprland/workspaces"
        ];

        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            active = "";
            default = "";
          };
        };

        "hyprland/window" = {
          format = "{}";
        };

        tray = {
          spacing = 10;
        };

        clock = {
          format = "<span color='#bf616a'> </span>{:%I:%M %p}";
          format-alt = "<span color='#bf616a'> </span>{:%a %b %d}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          interval = 5;
          format = "  {usage}%";
          max-length = 10;
        };

        memory = {
          interval = 30;
          format = " {}%";
          format-alt = "  {used:0.1f}G";
          max-length = 10;
        };

        network = {
          interval = 1;
          format-wifi = "   {signalStrength}%";
          tooltip-format-wifi = "{essid}";
          format-ethernet = " wired";
          on-click = "bash ~/.config/waybar/scripts/rofi-wifi-menu.sh";
          format-disconnected = "";
        };

        pulseaudio = {
          format = "{icon}   {volume}%";
          format-bluetooth = "  {volume}%";
          format-bluetooth-muted = "";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };
}
