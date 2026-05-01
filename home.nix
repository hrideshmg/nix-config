{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nvim-pkg.homeModules.default # import the HM module from the nvim flake
  ];

  home.username = "hridesh";
  home.homeDirectory = "/home/hridesh";

  home.packages = with pkgs; [
    neofetch
    firefox
    tmux
    stremio-linux-shell
    obsidian
    mpv
    nix-index
    wl-clipboard
    opencode
    python3
    rofimoji
    networkmanager_dmenu
    grimblast
    pavucontrol
    nemo-with-extensions
    vivid
    docker
    # spotify
    playerctl
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

  nvim.enable = true;

  programs.fish = {
    enable = true;

    shellAbbrs = {
      vim = "nvim";
      cdr = "cd (git rev-parse --show-toplevel)";

      dev = "tmux new-session -s dev nvim";
      devt = "tmux attach -t dev";
    };

    functions = {
      de = {
        description = "docker exec -it <container> bash";
        body = ''
          docker exec -it $argv[1] bash
        '';
      };
    };

    shellInit = ''
      set -gx EDITOR nvim
    '';

    interactiveShellInit = ''
      set -g fish_prompt_pwd_dir_length 0

      # Disable Greeting
      set -g fish_greeting

      set -gx LS_COLORS (vivid generate snazzy)

      # Color Scheme (adapted from Nord)
      set -g fish_color_normal normal
      set -g fish_color_command 5fd7d7
      set -g fish_color_keyword 81a1c1
      set -g fish_color_quote 87d787
      set -g fish_color_redirection b48ead --bold
      set -g fish_color_end 81a1c1
      set -g fish_color_error d70000
      set -g fish_color_param d8dee9
      set -g fish_color_comment 4c566a --italics
      set -g fish_color_selection d8dee9 --bold --background=434c5e
      set -g fish_color_search_match --bold --background=434c5e
      set -g fish_color_history_current e5e9f0 --bold
      set -g fish_color_operator 81a1c1
      set -g fish_color_escape ebcb8b
      set -g fish_color_cwd 5e81ac
      set -g fish_color_cwd_root bf616a
      set -g fish_color_option 8fbcbb
      set -g fish_color_valid_path --underline=single
      set -g fish_color_autosuggestion 4c566a
      set -g fish_color_user a3be8c
      set -g fish_color_host a3be8c
      set -g fish_color_host_remote ebcb8b
      set -g fish_color_history_current e5e9f0 --bold
      set -g fish_color_status bf616a
      set -g fish_color_cancel --reverse
      set -g fish_pager_color_prefix normal --bold --underline=single
      set -g fish_pager_color_progress 3b4252 --bold --background=d08770
      set -g fish_pager_color_completion e5e9f0
      set -g fish_pager_color_description ebcb8b --italics
      set -g fish_pager_color_selected_background --background=434c5e
      set -g fish_pager_color_secondary_completion 
      set -g fish_pager_color_selected_prefix 
      set -g fish_pager_color_secondary_description 
      set -g fish_pager_color_secondary_background 
      set -g fish_pager_color_background 
      set -g fish_pager_color_selected_description 
      set -g fish_pager_color_secondary_prefix 
      set -g fish_pager_color_selected_completion

      # build git prompt
      set -g __fish_git_prompt_showdirtystate 1
      set -g __fish_git_prompt_showuntrackedfiles 1
      set -g __fish_git_prompt_showcolorhints 1
      set -g __fish_git_prompt_use_informative_chars 1

      set -g __fish_git_prompt_color_prefix 949494
      set -g __fish_git_prompt_color_suffix 949494

      set -g __fish_git_prompt_char_dirtystate ''
      set -g __fish_git_prompt_char_invalidstate ''
      set -g __fish_git_prompt_char_stagedstate ''
      set -g __fish_git_prompt_char_untrackedfiles '󰐙'

      set -g __fish_git_prompt_color_dirtystate yellow
      set -g __fish_git_prompt_color_invalidstate red
      set -g __fish_git_prompt_color_stagedstate green
      set -g __fish_git_prompt_color_untrackedfiles cyan

      # build main prompt
      function fish_prompt
        set -l cyan (set_color 5fd7ff)
        set -l reset (set_color normal)
        set -l pwd_str "$cyan"(prompt_pwd)"$reset"
        set -l git_str (fish_git_prompt " (%s)")
        echo -n "$pwd_str$git_str -> "
      end
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
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

  programs.tmux = {
    enable = true;

    shortcut = "space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      		      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      		      set-option -g renumber-windows on
      		      unbind C-/

      		      # If only 1 pane, split it. If zoomed, unzoom. If multiple panes, toggle zoom.
      		      bind -n 'M-\' if-shell '[ "$(tmux list-panes | wc -l)" = 1 ]' 	\
      			'split-window -v -c "#{pane_current_path}" -l 25%'		\
      			'if-shell "[ -n \"$(tmux list-panes -F '''#F''' | grep Z)\" ]"	\
      			 "resize-pane -t1 -Z; select-pane -t2"				\
      			 "resize-pane -Z -t1"'

      		      # Window Navigation
      		      bind -n M-h previous-window
      		      bind -n M-l next-window

      		      # Quick Window Selection
      		      bind -n M-1 select-window -t 1
      		      bind -n M-2 select-window -t 2
      		      bind -n M-3 select-window -t 3
      		      bind -n M-4 select-window -t 4
      		      bind -n M-5 select-window -t 5

      		      # Splits and Session Management
      		      bind - split-window -v -c "#{pane_current_path}"
      		      bind \\ split-window -h -c "#{pane_current_path}"
      		      bind x kill-pane
      		      bind X kill-session
      		      set -g pane-active-border-style 'fg=#698DDA'

      		      # Pane Resizing (Prefix + Ctrl + hjkl)
      		      bind -r C-j resize-pane -D 2
      		      bind -r C-k resize-pane -U 2
      		      bind -r C-h resize-pane -L 2
      		      bind -r C-l resize-pane -R 2
      		    '';

    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      minimal-tmux-status
      sensible
      yank
      vim-tmux-navigator
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "hridesh699@gmail.com";
        name = "Hridesh MG";
        signingkey = "85C0EF6C72674D7B";
      };
      signing.signByDefault = false;
      alias = {
        co = "checkout";
        cm = "commit -m";
        ca = "commit -am";
        st = "status";
        br = "branch";
        fp = "push --force";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        hotfix = "commit --amend --no-edit -a";
        pushremote = "!git push $(git config --get branch.$(git symbolic-ref HEAD --short).pushRemote) +@:$(git config --get branch.$(git symbolic-ref HEAD --short).merge | awk -F / '{print $NF}')";
      };
      core.editor = "nvim";
      push.autoSetupRemote = true;
      safe.directory = [
        "/etc/nixos"
      ];
      commit.gpgsign = false;
      tag.gpgsign = false;
      pull.rebase = true;
    };
    ignores = [
      ".in"
      ".out"
      ".aider*"
      "mprocs.yaml"
    ];
  };

  services.wayvnc = {
    enable = true;
    autoStart = true;
    settings.address = "0.0.0.0";
    settings.port = 5900;
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
        "HDMI-A-1,${./wallpapers/unit01.png}"
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
        active_opacity = 0.85;
        inactive_opacity = 0.8;
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
        "opacity 1.0 override 1.0 override, class:^(firefox)$"
        "opacity 1.0 override 1.0 override, class:^(Google-chrome)$"
        "opacity 1.0 override 1.0 override, class:^(obsidian)$"
        "opacity 1.0 override 1.0 override, class:^(org.pwmt.zathura)$"

        # Floating rules
        "float, class:^(firefox)$, title:^(Library)$"
        "float, title:^(Choose Files)$"
        "float, title:^(floating_foot)$"
        "float, title:^(Save As)$"
        "float, title:^(Open)$"
        "float, title:^(blueman)$"

        # Tiling rule
        "tile, title:^(scrcpy)$"
      ];

      # --- Keybinds ---
      bind = [
        # Launch Apps
        "SUPER, Z, exec, spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "SUPER, B, exec, firefox"
        "SUPER, N, exec, obsidian"
        "SUPER, C, exec, google-chrome-stable"

        "SUPER, I, exec, networkmanager_dmenu"
        "SUPER, W, exec, rofi -show window"
        "SUPER, R, exec, rofi -show run"
        "SUPER, E, exec, rofi -show calc -modi calc -no-show-match -no-sort"
        "SUPER, period, exec, rofimoji --skin-tone neutral"

        "SUPER, Return, exec, foot"
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
        "SUPER, Q, killactive,"
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
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

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
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move to Workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
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

      # --- Autostart ---
      "exec-once" = [
        "hyprpaper"
        "wlsunset -l 9.9 -L 76.2 -t 4600"
        "discord --start-minimized --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "waybar"
      ];
    };
  };

  home.stateVersion = "25.11";
}
