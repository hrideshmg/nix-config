{ monitors, ... }:
{
  imports = [
    ./appearance.nix
    ./rules.nix
    ./keybinds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      monitor = builtins.map (
        monitor: "${monitor.name}, ${monitor.resolution}@${monitor.refresh}, auto, ${monitor.scaling}"
      ) monitors;

      "exec-once" = [
        "hyprpaper"
        "waybar"
      ];

      env = [
        "HYPRCURSOR_THEME,McMojave"
        "HYPRCURSOR_SIZE,32"
      ];

      input = {
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.5;
        };
        sensitivity = 0.1;
      };

      device = {
        name = "logitech-g102-prodigy-gaming-mouse";
        sensitivity = -0.2;
      };

      # --- Layouts & Misc ---
      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      misc.disable_hyprland_logo = true;
      xwayland.force_zero_scaling = true;
      cursor.inactive_timeout = 10;
    };
  };
}
