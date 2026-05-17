{
  username,
  ...
}:
{
  programs = {
    chromium = {
      enable = true;
      commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];
    };

    firefox = {
      enable = true;
      profiles.${username} = {
        settings = {
          # Set a custom download directory
          "browser.download.dir" = "/home/${username}/downloads/";

          # 2 = use the custom dir above
          # 0 = desktop, 1 = system Downloads folder
          "browser.download.folderList" = 2;
        };
      };
    };
  };
}
