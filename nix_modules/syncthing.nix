{
  username,
  ...
}:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = username;
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
    settings = {
      devices = {
        "Nothing 3A" = {
          id = "FI75FLT-7QXDIOE-SXNJFUR-4NL5DKY-WV4FKIJ-TZVUNHW-WJ3A262-6QY5FQX";
        };
        "Windows PC" = {
          id = "FSGTJ5K-F5BXUKI-WOCJEE3-UWLNPCR-WB4FRBZ-DZTVWU2-PR6HY2L-Q5PIVA3";
        };
      };
      folders = {
        "obsidian" = {
          path = "/home/${username}/documents/obsidian-vault";
          devices = [
            "Nothing 3A"
            "Windows PC"
          ];
        };
        "keepass_sync" = {
          path = "/home/${username}/documents/keepass_sync";
          devices = [
            "Nothing 3A"
            "Windows PC"
          ];
        };
        "college" = {
          path = "/home/${username}/college";
          devices = [
            "Nothing 3A"
            "Windows PC"
          ];
        };
      };
    };
  };

}
