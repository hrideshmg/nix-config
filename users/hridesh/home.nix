{ pkgs, ... }:
{
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
