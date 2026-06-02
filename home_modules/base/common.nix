{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nvim-pkg.homeModules.default # import the HM module from the nvim flake
  ];

  home.packages = with pkgs; [
    # nix
    git-crypt
    nix-index
    nh

    # development
    docker
    python3

    # productivity
    keepassxc
    obsidian

    # file manager
    nemo-with-extensions

    # misc
    libnotify
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
