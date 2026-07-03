{ monitors, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      # Nix will convert these to /nix/store/... paths automatically
      preload = builtins.map (name: "${../../wallpapers + "/${name}"}") (
        builtins.attrNames (builtins.readDir ../../wallpapers)
      );

      wallpaper = map (monitor: "${monitor.name},${monitor.wallpaper}") monitors;
    };
  };
}
