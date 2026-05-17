{ monitors, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      # Nix will convert these to /nix/store/... paths automatically
      preload = [
        "${../../../wallpapers/anime_night.png}"
        "${../../../wallpapers/unit01.png}"
        "${../../../wallpapers/rei_field.png}"
        "${../../../wallpapers/astro_girl.png}"
      ];

      wallpaper = map (monitor: "${monitor.name},${monitor.wallpaper}") monitors;
    };
  };
}
