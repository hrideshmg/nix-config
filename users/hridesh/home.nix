{ pkgs, ... }:
{
  imports = [
    ../../home_modules/base
    ../../home_modules/base/media.nix

    ../../home_modules/shell
    ../../home_modules/hyprland

    ../../home_modules/hyprland/waybar
    ../../home_modules/hyprland/waybar/laptop_widgets.nix

    ../../home_modules/hyprland/services/swaylock.nix
    ../../home_modules/hyprland/services/power_monitor.nix
  ];

  hyprland.mainMod = "ALT";

  home.packages = with pkgs; [
    spotify
    discord
    stremio-linux-shell
  ];

  wayland.windowManager.hyprland.settings = {
    "exec-once" = [
      "wlsunset -l 9.9 -L 76.2 -t 4600"
      "discord --start-minimized --disable-gpu"
    ];
  };
}
