{ pkgs, ... }:

{
  imports = [
    ./fish
    ./tmux
    ./foot.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    fastfetch
    vivid
  ];
}
