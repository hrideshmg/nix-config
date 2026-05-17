{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify
    discord
    stremio-linux-shell
  ];
}
