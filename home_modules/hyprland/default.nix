{
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
  ];

  # this creates a custom nixos option available at config.hyprland.mainMod
  options.hyprland.mainMod = lib.mkOption {
    type = lib.types.str;
    default = "SUPER";
    description = "The main modifier key used for hyprland keybindings";
  };

  config = {
    home.packages = with pkgs; [
      # Utils
      grimblast
      wl-clipboard

      # rofi plugins
      rofimoji
      networkmanager_dmenu

      # cursor theme
      inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # screenshots directory for grimblast
    home.sessionVariables = {
      XDG_SCREENSHOTS_DIR = "$HOME/media/screenshots/";
    };
    home.activation.screenshotsdir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ~/media/screenshots
    '';

    gtk = {
      enable = true;
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
    };

    programs.rofi = {
      enable = true;
      theme = "Arc-Dark";
      plugins = with pkgs; [
        # Add a calculator to rofi
        rofi-calc
      ];
    };
  };
}
