{
  config,
  pkgs,
  inputs,
  secrets,
  ...
}:

{
  home.packages = with pkgs; [
    firefox
    obsidian
    wl-clipboard
    opencode
    rofimoji
    networkmanager_dmenu
    grimblast
    nemo-with-extensions
    docker
    keepassxc
    spotify
    wlsunset
    discord
    font-awesome
    inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default

  ];

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };

  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
    plugins = with pkgs; [
      rofi-calc
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      env = [
        "HYPRCURSOR_THEME,McMojave"
        "HYPRCURSOR_SIZE,32"
      ];

      monitor = [
        "Virtual-1, 1920x1080, auto, 1"
      ];
      # monitor = [
      #   "eDP-1,2560x1440@165,1920x0,1.25"
      #   "DP-1,1920x1080@60,0x0,1"
      #   ", preferred, auto, 1, mirror, eDP-1"
      # ];

      # --- Workspace Bindings ---
      # workspace = [
      #   "1,monitor:DP-1, default:true"
      #   "2,monitor:DP-1"
      #   "3,monitor:eDP-1"
      #   "4,monitor:eDP-1"
      # ];

      # --- Input & Device ---
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

      # --- Layouts & Misc ---
      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      cursor = {
        inactive_timeout = 10;
        no_hardware_cursors = true;
      };

      # --- Window Rules ---
      windowrule = [
        # Workspace rule (Special workspace/scratchpad)
        "float, workspace:name:special"

        # Opacity rules (Active, Inactive, Fullscreen)
        "opacity 0.85 override 0.8 override, class:^(foot)$"
        "opacity 1.0 override 1.0 override, title:^tmux.*"

        # Floating rules
        "float, class:^(firefox)$, title:^(Library)$"
        "float, title:^(Choose Files)$"
        "float, size 40% 40%, title:^(floating_foot)$"
        "float, title:^(Save As)$"
        "float, title:^(Open)$"
        "float, title:^(blueman)$"

        # Tiling rule
        "tile, title:^(scrcpy)$"
      ];

      # --- Keybinds ---
      bind = [
        # Launch Apps
        "SUPER, Z, exec, spotify --disable-gpu"
        "SUPER, B, exec, firefox"
        "SUPER, N, exec, obsidian --disable-gpu"
        "SUPER, C, exec, google-chrome-stable"

        "SUPER, I, exec, networkmanager_dmenu"
        "SUPER, W, exec, rofi -show window"
        "SUPER, R, exec, rofi -show drun"
        "SUPER, E, exec, rofi -show calc -modi calc -no-show-match -no-sort"
        "SUPER, period, exec, rofimoji --skin-tone neutral"

        "alt, Return, exec, foot"
        "SUPER SHIFT, Return, exec, foot --title floating_foot"

        # Screenshots
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast save area  && notify-send -i folder-pictures 'Saved Screenshot' '~/Pictures/screenshots'"

        # Misc & System
        "SUPER, X, exec, swaylock"

        # Brightness (Discrete taps)
        ", XF86MonBrightnessDown, exec, brightnessctl s 3%- -n 1 -d 'intel_backlight'; brightnessctl s 3%- -n 1 -d 'nvidia_0'"
        ", XF86MonBrightnessUp, exec, brightnessctl s +3% -n 1 -d 'intel_backlight'; brightnessctl s +3% -n 1 -d 'nvidia_0'"

        # Media Keys
        ", XF86AudioPlay, exec, playerctl -p spotify,firefox,%any play-pause"
        ", XF86AudioPause, exec, playerctl -p spotify,firefox,%any play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # Window Management
        "alt, Q, killactive,"
        "SUPER SHIFT, Q, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit "
        "SUPER, SPACE, togglefloating,"
        "SUPER, S, togglesplit,"
        "SUPER, M, fullscreen, 1"
        "SUPER SHIFT, M, fullscreen, 2"
        "SUPER, O, exec, hyprctl dispatch setprop active opaque toggle"

        # Special Workspace
        "SUPER, a, togglespecialworkspace"
        "SUPER SHIFT, a, movetoworkspace, special"
        "SUPER, c, exec, hyprctl dispatch centerwindow"

        # Move focus (Vim keys)
        "alt, H, movefocus, l"
        "alt, L, movefocus, r"
        "alt, K, movefocus, u"
        "alt, J, movefocus, d"

        # Move Windows
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"

        # Resize Windows (Fine)
        "SUPER CTRL, H, resizeactive, -5% 0"
        "SUPER CTRL, L, resizeactive, 5% 0"
        "SUPER CTRL, K, resizeactive, 0 -20"
        "SUPER CTRL, J, resizeactive, 0 5%"

        # Resize Windows (Coarse)
        "SUPER SHIFT CTRL, H, resizeactive, -20% 0"
        "SUPER SHIFT CTRL, L, resizeactive, 20% 0"
        "SUPER SHIFT CTRL, K, resizeactive, 0 -20%"
        "SUPER SHIFT CTRL, J, resizeactive, 0 20%"

        # Workspaces (Switching)
        "alt, 1, workspace, 1"
        "alt, 2, workspace, 2"
        "alt, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move to Workspace
        "alt SHIFT, 1, movetoworkspace, 1"
        "alt SHIFT, 2, movetoworkspace, 2"
        "alt SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Mouse Scroll Workspaces
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];

      binde = [
        "SUPER, Down, exec, brightnessctl s 3%- -n 1 -d 'intel_backlight'"
        "SUPER, Up, exec, brightnessctl s +3% -n 1 -d 'intel_backlight'"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # --- Autostart ---
      "exec-once" = [
        "hyprpaper"
        "wlsunset -l 9.9 -L 76.2 -t 4600"
        "discord --start-minimized --disable-gpu"
        "waybar"
      ];
    };
  };
}
