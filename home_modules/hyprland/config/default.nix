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
        monitor:
        "${monitor.name}, ${monitor.resolution}@${monitor.refresh}, ${monitor.position}, ${monitor.scaling}"
      ) monitors;

      workspace =
        if builtins.length monitors == 2 then
          [
            "1, monitor:${(builtins.elemAt monitors 0).name}, default:true"
            "2, monitor:${(builtins.elemAt monitors 0).name}"
          ]
        else
          [ ];

      "exec-once" = [
        "hyprpaper"
        "waybar"
      ];

      env = [
        "HYPRCURSOR_THEME,McMojave"
        "HYPRCURSOR_SIZE,32"
        # screenshots directory for grimblast
        "XDG_SCREENSHOTS_DIR,$HOME/media/screenshots/"
      ];

      gesture = "3, horizontal, workspace";

      input = {
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.9;
        };
        sensitivity = 0.1;
        kb_options = "ctrl:nocaps";
      };

      device = {
        name = "logitech-g102-prodigy-gaming-mouse";
        sensitivity = -0.4;
      };

      # --- Layouts & Misc ---
      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      binds = {
        movefocus_cycles_fullscreen = true;
      };

      misc.disable_hyprland_logo = true;
      xwayland.force_zero_scaling = true;
      cursor.inactive_timeout = 10;
    };
  };
}
