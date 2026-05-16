{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nvim-pkg.homeModules.default # import the HM module from the nvim flake
  ];

  home.packages = with pkgs; [
    git-crypt
    nix-index
  ];

  # Primary editor
  nvim.enable = true;

  # Smarter cd command
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };
}
