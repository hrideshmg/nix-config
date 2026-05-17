{ pkgs, ... }:

{
  imports = [
    ./fish
    ./tmux
    ./foot.nix
  ];

  home.packages = with pkgs; [
    fastfetch
    vivid
  ];
}
