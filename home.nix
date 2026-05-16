{
  config,
  pkgs,
  inputs,
  secrets,
  ...
}:

{
  home.packages = with pkgs; [
    neofetch
    firefox
    tmux
    obsidian
    wl-clipboard
    opencode
    rofimoji
    networkmanager_dmenu
    grimblast
    nemo-with-extensions
    vivid
    docker
    keepassxc
    spotify
    wlsunset
    discord
    font-awesome
    inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh1
    (pkgs.symlinkJoin {
      name = "stremio";
      paths = [ pkgs.stremio-linux-shell ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/stremio \
          --set LIBGL_ALWAYS_SOFTWARE 1 \
          --set GALLIUM_DRIVER llvmpipe \
          --add-flags "--disable-gpu" \
          --add-flags "--disable-gpu-compositing" \
          --add-flags "--disable-software-rasterizer"
      '';
    })
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka NFM:size=14";
      };
      colors = {
        background = "2B2E37";
        cursor = "2B2E37 FFFFFF";
      };
    };
  };

  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
    plugins = with pkgs; [
      rofi-calc
    ];
  };

  services.wayvnc = {
    enable = true;
    autoStart = true;
    settings = {
      address = "0.0.0.0";
      port = 5900;
      enable_auth = true;
      relax_encryption = true;
      use_relative_paths = true;
      username = "operator";
      password = secrets.wayvnc.password;
      rsa_private_key_file = "${./secrets/wayvnc/rsa_key.pem}";
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      # Nix will convert these to /nix/store/... paths automatically
      preload = [
        "${./wallpapers/anime_night.png}"
        "${./wallpapers/unit01.png}"
        "${./wallpapers/rei_field.png}"
        "${./wallpapers/astro_girl.png}"
      ];

      wallpaper = [
        "Virtual-1,${./wallpapers/unit01.png}"
      ];
    };
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 120;
      indicator-thickness = 5;
      timestr = "%I:%M %p";

      inside-wrong-color = "f38ba8";
      ring-wrong-color = "11111b";
      inside-clear-color = "a6e3a1";
      ring-clear-color = "11111b";
      inside-ver-color = "ebf2ff";
      ring-ver-color = "2B2E37";
      text-color = "FFFFFF";
      ring-color = "2B2E37";
      key-hl-color = "DBD5C7";
      line-color = "2B2E37";
      inside-color = "11111b00";
      separator-color = "00000000";

      effect-blur = "10x7";
      effect-vignette = "0.2:0.2";
    };
  };

  programs.waybar = {
    enable = true;

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
          "custom/power_profile"
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

        "custom/power_profile" = {
          format = "{}";
          exec = "~/.config/waybar/scripts/power_profile.sh";
          return-type = "json";
          on-click = "~/.config/waybar/scripts/power_profile.sh next && pkill -RTMIN+8 waybar";
          signal = 8;
          interval = "once";
          tooltip = true;
        };

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

        bluetooth = {
          on-click = "~/.config/waybar/scripts/rofi-bluetooth &";
          format = " {status}";
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
      };
    };

    style = ''
      @define-color base00 #181818;
      @define-color base01 #2b2e37;
      @define-color base02 #3b3e47;
      @define-color base03 #585858;
      @define-color base04 #b8b8b8;
      @define-color base05 #d8d8d8;
      @define-color base06 #e8e8e8;
      @define-color base07 #f8f8f8;
      @define-color base08 #ab4642;
      @define-color base09 #dc9656;
      @define-color base0A #f7ca88;
      @define-color base0B #a1b56c;
      @define-color base0C #86c1b9;
      @define-color base0D #7cafc2;
      @define-color base0E #ba8baf;
      @define-color base0F #a16946;

      * {
        transition: none;
        box-shadow: none;
      }

      #waybar {
        font-family: "Source Code Pro", sans-serif;
        font-size: 1.2em;
        font-weight: 400;
        color: @base04;
        background: @base01;
      }

      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        margin: 4px 0;
        padding: 0 4px;
        color: @base05;
      }

      #workspaces button.active {
        border-radius: 4px;
        background-color: @base02;
      }

      #workspaces button.urgent {
        color: rgba(238, 46, 36, 1);
      }

      #tray {
        margin: 4px 4px;
        border-radius: 4px;
        background-color: @base02;
      }

      #tray * {
        padding: 0 6px;
        border-left: 1px solid @base00;
      }

      #tray *:first-child {
        border-left: none;
      }

      #mode, #battery, #cpu, #memory, #network, #pulseaudio,
      #idle_inhibitor, #backlight, #custom-storage, #custom-updates,
      #custom-weather, #custom-mail, #clock, #temperature {
        margin: 4px 2px;
        padding: 0 6px;
        background-color: @base02;
        border-radius: 4px;
        min-width: 20px;
      }

      #cpu {
        padding: 4px;
      }

      #pulseaudio.muted {
        color: @base0F;
      }

      #pulseaudio.bluetooth {
        color: @base0C;
      }

      #clock {
        margin-left: 0px;
        margin-right: 4px;
        background-color: transparent;
      }

      #temperature.critical {
        color: @base0F;
      }

      #window {
        font-size: 0.9em;
        font-weight: 400;
        font-family: sans-serif;
      }

      #custom-power_profile {
        font-size: 1.4em;
        margin: 4px 2px 4px 4px;
        padding: 0px 10px 0px 3px;
        background-color: @base02;
        border-radius: 4px;
        min-width: 20px;
      }

      #custom-power_profile.quiet { color: #a6e3a1; }
      #custom-power_profile.balanced { color: #89b4fa; }
      #custom-power_profile.perf { color: #f38ba8; }
    '';
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
