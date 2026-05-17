{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # --- General & Decoration ---
    general = {
      gaps_in = 3;
      gaps_out = 5;
      "col.active_border" = "rgba(f5f2edff) rgba(f5f2edff) 45deg";
      "col.inactive_border" = "0xff382D2E";
      no_focus_fallback = true;
      layout = "dwindle";
    };

    decoration = {
      rounding = 5;
      blur = {
        size = 7;
        passes = 2;
        xray = true;
        ignore_opacity = true;
      };
    };

    # --- Animations ---
    animations = {
      enabled = true;
      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.0, 0.1, 1.0"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];
      animation = [
        "windows, 1, 9, wind, slide"
        "windowsIn, 1, 9, winIn, slide"
        "windowsOut, 1, 9, winOut, slide"
        "windowsMove, 1, 9, wind, slide"
        "border, 1, 1, liner"
        "borderangle, 1, 30, liner, loop"
        "fade, 1, 9, default"
        "workspaces, 1, 5, wind"
      ];
    };
  };
}
