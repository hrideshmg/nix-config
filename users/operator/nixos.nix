{ config, pkgs, ... }:

{
  programs.fish.enable = true;
  users.users.operator.shell = pkgs.fish;
}
