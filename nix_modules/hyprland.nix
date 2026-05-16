{
  config,
  pkgs,
  username,
  ...
}:

{
  programs.hyprland.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = username;
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
