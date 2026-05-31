{ ... }:
{
  services.mako.enable = true;

  # Disable dunst from intercepting blueman messages
  dconf.settings = {
    "org/blueman/general" = {
      notification-daemon = false;
    };
  };
}
