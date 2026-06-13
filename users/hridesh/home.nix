{ pkgs, ... }:
{
  imports = [
    ../../home_modules/base
    ../../home_modules/base/media.nix

    ../../home_modules/shell
    ../../home_modules/hyprland
    ../../home_modules/programs/stremio_nogpu.nix

    # Laptop specific modules
    ../../home_modules/hyprland/waybar/laptop_widgets.nix
    ../../home_modules/hyprland/modules/swaylock.nix
    ../../home_modules/hyprland/modules/power_monitor.nix

    ../../home_modules/programs/coding_agents
  ];

  home.packages = with pkgs; [
    spotify
    discord
  ];

  wayland.windowManager.hyprland.settings = {
    "exec-once" = [
      "wlsunset -l 9.9 -L 76.2 -t 4600"
      "discord --start-minimized --disable-gpu"
    ];
  };
}
