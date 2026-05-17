{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./services/hyprpaper.nix
    ./waybar
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
