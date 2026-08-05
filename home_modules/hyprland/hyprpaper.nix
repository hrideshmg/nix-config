{ monitors, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      # Nix will convert these to /nix/store/... paths automatically
      preload = map (name: "${../../wallpapers + "/${name}"}") (
        builtins.attrNames (builtins.readDir ../../wallpapers)
      );

      wallpaper = map (m: {
        monitor = m.name;
        path = m.wallpaper;
        fit_mode = "contain";
      }) monitors;

      splash = "false";
    };
  };
}
