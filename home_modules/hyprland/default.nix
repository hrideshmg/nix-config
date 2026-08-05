{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./waybar
    ./hyprpaper.nix
    ./dunst.nix
    ./config
    ./rofi.nix
  ];

  # this creates a custom nixos option available at config.hyprland.mainMod
  options.hyprland.mainMod = lib.mkOption {
    type = lib.types.str;
    default = "SUPER";
    description = "The main modifier key used for hyprland keybindings";
  };

  config = {
    home.packages = with pkgs; [
      hyprpolkitagent

      # Utils
      grimblast
      wl-clipboard

      # cursor theme
      inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.activation.screenshotsdir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ~/media/screenshots
    '';

    gtk = {
      enable = true;
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
      gtk4.theme = config.gtk.theme;
    };
  };
}
