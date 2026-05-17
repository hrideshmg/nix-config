{ inputs, pkgs, ... }:
{
  imports = [
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [
    grimblast
    wl-clipboard

    rofimoji
    networkmanager_dmenu

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
      rofi-calc
    ];
  };
}
