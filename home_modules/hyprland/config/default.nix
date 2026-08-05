{ monitors, ... }:
let
  monitorConfig = builtins.concatStringsSep "\n" (
    builtins.map (monitor: ''
      hl.monitor({
        output = "${monitor.name}",
        mode = "${monitor.resolution}@${monitor.refresh}",
        position = "${monitor.position}",
        scale = ${monitor.scaling},
      })
    '') monitors
  );
  workspaceConfig =
    if builtins.length monitors == 2 then
      let
        primaryMonitor = (builtins.elemAt monitors 0).name;
      in
      ''
        hl.workspace_rule({ workspace = "1", monitor = "${primaryMonitor}", default = true })
        hl.workspace_rule({ workspace = "2", monitor = "${primaryMonitor}" })
      ''
    else
      "";
in
{
  imports = [
    ./appearance.nix
    ./rules.nix
    ./keybinds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    systemd.enable = true;

    extraConfig = ''
      ${monitorConfig}
      ${workspaceConfig}

      hl.on("hyprland.start", function()
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("waybar")
      end)

      hl.env("HYPRCURSOR_THEME", "McMojave")
      hl.env("HYPRCURSOR_SIZE", "32")
      hl.env("XDG_SCREENSHOTS_DIR", os.getenv("HOME") .. "/media/screenshots/")

      hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace",
      })

      hl.config({
        input = {
          numlock_by_default = true,
          touchpad = {
            natural_scroll = true,
            scroll_factor = 0.9,
          },
          sensitivity = 0.1,
          kb_options = "ctrl:nocaps",
        },
        dwindle = {
          force_split = 2,
          preserve_split = true,
        },
        binds = {
          movefocus_cycles_fullscreen = true,
        },
        misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
        },
        xwayland = {
          force_zero_scaling = true,
        },
        cursor = {
          inactive_timeout = 10,
        },
      })

      hl.device({
        name = "logitech-g102-prodigy-gaming-mouse",
        sensitivity = -0.4,
      })
    '';
  };
}
