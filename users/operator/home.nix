{ secrets, ... }:
{
  imports = [
    ../../home_modules/base
    ../../home_modules/shell
    ../../home_modules/hyprland
    ../../home_modules/hyprland/waybar
  ];

  hyprland.mainMod = "ALT";

  services.wayvnc = {
    enable = true;
    autoStart = true;
    settings = {
      address = "0.0.0.0";
      port = 5900;
      enable_auth = true;
      relax_encryption = true;
      use_relative_paths = true;
      username = "operator";
      password = secrets.wayvnc.password;
      rsa_private_key_file = "${../../secrets/wayvnc/rsa_key.pem}";
    };
  };

  wayland.windowManager.hyprland.settings.cursor.no_hardware_cursors = true;
}
