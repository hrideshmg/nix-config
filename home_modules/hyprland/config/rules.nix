{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # --- Window Rules ---
    windowrule = [
      # Workspace rule (Special workspace/scratchpad)
      "float, workspace:name:special"

      # Opacity rules (Active, Inactive, Fullscreen)
      "opacity 0.85 override 0.8 override, class:^(foot)$"
      "opacity 1.0 override 1.0 override, title:^tmux.*"

      # Floating rules
      "float, class:^(firefox)$, title:^(Library)$"
      "float, class:^(firefox)$, title:^(OpenCode)$"
      "float, class:^(firefox)$, title:claude"
      "float, title:^(Choose Files)$"
      "float, size 40% 40%, title:^(floating_foot)$"
      "float, title:^(Save As)$"
      "float, title:^(Open)$"
      "float, title:^(blueman)$"

      # Tiling rule
      "tile, title:^(scrcpy)$"
    ];
  };
}
