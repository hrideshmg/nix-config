{ pkgs, ... }:
{
  imports = [
    ../../home_modules/base
    ../../home_modules/base/media.nix

    ../../home_modules/shell
    ../../home_modules/hyprland

    # Laptop specific modules
    ../../home_modules/hyprland/waybar/laptop_widgets.nix
    ../../home_modules/hyprland/modules/swaylock.nix
    ../../home_modules/hyprland/modules/power_monitor.nix

    ../../home_modules/programs/coding_agents
    ../../home_modules/programs/zathura.nix
  ];

  home.packages = with pkgs; [
    spotify
    discord
    onlyoffice-desktopeditors
    stremio-linux-shell
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("wlsunset -l 9.9 -L 76.2 -t 4600")
      hl.exec_cmd("discord --start-minimized --disable-gpu")
    end)
  '';
}
