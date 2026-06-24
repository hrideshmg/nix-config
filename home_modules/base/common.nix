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
    devenv

    # development
    mprocs
    docker
    python3
    linux-manual
    man-pages

    # productivity
    keepassxc
    obsidian

    # file manager
    nemo-with-extensions

    # misc
    libnotify
    tldr
    ncdu
  ];

  # Primary editor
  nvim.enable = true;

  # Smarter cd command
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  # disable middle mouse button paste
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-enable-primary-paste = false;
    };
  };
}
