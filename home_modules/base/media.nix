{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    pavucontrol
    playerctl
  ];
}
