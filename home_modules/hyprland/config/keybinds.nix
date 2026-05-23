{ config, ... }:
let
  mainMod = config.hyprland.mainMod;
in
{
  wayland.windowManager.hyprland.settings = {
    # --- Keybinds ---
    bind = [
      # Launch Apps
      "${mainMod}, Z, exec, spotify --disable-gpu"
      "${mainMod}, B, exec, firefox"
      "${mainMod}, N, exec, obsidian --disable-gpu"
      "${mainMod}, C, exec, google-chrome-stable"

      "${mainMod}, I, exec, networkmanager_dmenu -i"
      "${mainMod}, W, exec, rofi -i -show window"
      "${mainMod}, R, exec, rofi -i -show drun"
      "${mainMod}, E, exec, rofi -show calc -modi calc -no-show-match -no-sort"
      "${mainMod}, period, exec, rofimoji --skin-tone neutral"

      "${mainMod}, Return, exec, foot"
      "${mainMod} SHIFT, Return, exec, foot --title floating_foot"

      # Screenshots
      ", Print, exec, grimblast copy area"
      "SHIFT, Print, exec, grimblast save area  && notify-send -i folder-pictures 'Saved Screenshot' '~/Pictures/screenshots'"

      # Misc & System
      "${mainMod}, X, exec, swaylock"

      # Media Keys
      ", XF86AudioPlay, exec, playerctl -p spotify,firefox,%any play-pause"
      ", XF86AudioPause, exec, playerctl -p spotify,firefox,%any play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+"

      # Window Management
      "${mainMod}, Q, killactive,"
      "${mainMod} SHIFT, Q, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit "
      "${mainMod}, SPACE, togglefloating,"
      "${mainMod}, S, togglesplit,"
      "${mainMod}, M, fullscreen, 1"
      "${mainMod} SHIFT, M, fullscreen, 2"
      "${mainMod}, O, exec, hyprctl dispatch setprop active opaque toggle"

      # Special Workspace
      "${mainMod}, a, togglespecialworkspace"
      "${mainMod} SHIFT, a, movetoworkspace, special"
      "${mainMod}, c, exec, hyprctl dispatch centerwindow"

      # Move focus (Vim keys)
      "${mainMod}, H, movefocus, l"
      "${mainMod}, L, movefocus, r"
      "${mainMod}, K, movefocus, u"
      "${mainMod}, J, movefocus, d"

      # Move Windows
      "${mainMod} SHIFT, H, movewindow, l"
      "${mainMod} SHIFT, L, movewindow, r"
      "${mainMod} SHIFT, K, movewindow, u"
      "${mainMod} SHIFT, J, movewindow, d"

      # Resize Windows (Fine)
      "${mainMod} CTRL, H, resizeactive, -5% 0"
      "${mainMod} CTRL, L, resizeactive, 5% 0"
      "${mainMod} CTRL, K, resizeactive, 0 -20"
      "${mainMod} CTRL, J, resizeactive, 0 5%"

      # Resize Windows (Coarse)
      "${mainMod} SHIFT CTRL, H, resizeactive, -20% 0"
      "${mainMod} SHIFT CTRL, L, resizeactive, 20% 0"
      "${mainMod} SHIFT CTRL, K, resizeactive, 0 -20%"
      "${mainMod} SHIFT CTRL, J, resizeactive, 0 20%"

      # Workspaces (Switching)
      "${mainMod}, 1, workspace, 1"
      "${mainMod}, 2, workspace, 2"
      "${mainMod}, 3, workspace, 3"
      "${mainMod}, 4, workspace, 4"
      "${mainMod}, 5, workspace, 5"
      "${mainMod}, 6, workspace, 6"
      "${mainMod}, 7, workspace, 7"
      "${mainMod}, 8, workspace, 8"
      "${mainMod}, 9, workspace, 9"
      "${mainMod}, 0, workspace, 10"

      # Move to Workspace
      "${mainMod} SHIFT, 1, movetoworkspace, 1"
      "${mainMod} SHIFT, 2, movetoworkspace, 2"
      "${mainMod} SHIFT, 3, movetoworkspace, 3"
      "${mainMod} SHIFT, 4, movetoworkspace, 4"
      "${mainMod} SHIFT, 5, movetoworkspace, 5"
      "${mainMod} SHIFT, 6, movetoworkspace, 6"
      "${mainMod} SHIFT, 7, movetoworkspace, 7"
      "${mainMod} SHIFT, 8, movetoworkspace, 8"
      "${mainMod} SHIFT, 9, movetoworkspace, 9"
      "${mainMod} SHIFT, 0, movetoworkspace, 10"
    ];

    binde = [
      "${mainMod}, Down, exec, brightnessctl --min-value=2 s 3%- -n 1"
      "${mainMod}, Up, exec, brightnessctl s +3% -n 1"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
    ];
  };
}
