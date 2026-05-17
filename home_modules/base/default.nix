{ username, ... }:

{
  imports = [
    ./common.nix
    ./git.nix
    ./media.nix
    ./browsers.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11";
}
