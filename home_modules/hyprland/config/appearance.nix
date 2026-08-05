{ ... }:
{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.config({
      general = {
        gaps_in = 3,
        gaps_out = 5,
        col = {
          active_border = {
            colors = { "rgba(f5f2edff)", "rgba(f5f2edff)" },
            angle = 45,
          },
          inactive_border = "0xff382D2E",
        },
        no_focus_fallback = true,
        layout = "dwindle",
      },
      decoration = {
        rounding = 5,
        blur = {
          size = 7,
          passes = 2,
          xray = true,
          ignore_opacity = true,
        },
      },
      animations = {
        enabled = true,
      },
    })

    hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
    hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.0 }, { 0.1, 1.0 } } })
    hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
    hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

    hl.animation({ leaf = "windows", enabled = true, speed = 9, bezier = "wind", style = "slide" })
    hl.animation({ leaf = "windowsIn", enabled = true, speed = 9, bezier = "winIn", style = "slide" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 9, bezier = "winOut", style = "slide" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 9, bezier = "wind", style = "slide" })
    hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
    hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", loop = true })
    hl.animation({ leaf = "fade", enabled = true, speed = 9, bezier = "default" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })
  '';
}
