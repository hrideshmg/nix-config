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
      "float, class:^(.blueman-manager-wrapped)$"
      "float, class:^(firefox)$, title:^(OpenCode)$"
      "float, class:^(firefox)$, title:claude"
      "float, size 40% 40%, title:^(floating_foot)$"
      "float, title:^(Save As)$"
      "float, title:^(Open)$"
      "float, title:^(blueman)$"
      "float, title:^(KeePassXC - Browser Access Request)$"
      "float, title:^(Open File(s)?)$"

      "float, title:^(Choose Files)$"
      "float, title:^(Save File)$"

      # Tiling rule
      "tile, title:^(scrcpy)$"
    ];
  };
}
