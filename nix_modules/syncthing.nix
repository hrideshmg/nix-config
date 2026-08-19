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
        "Citadel" = {
          id = "RWJ5ODI-ELBEXIS-4I7P7RS-GCLPR3S-UYH5DVZ-QOCXQWR-U4VD5AT-3VRAOQN";
        };
      };
      folders = {
        "obsidian" = {
          path = "/home/${username}/documents/obsidian-vault";
          devices = [
            "Nothing 3A"
            "Citaldel"
          ];
        };
        "keepass_sync" = {
          path = "/home/${username}/documents/keepass_sync";
          devices = [
            "Nothing 3A"
            "Citadel"
          ];
        };
        "college" = {
          path = "/home/${username}/college";
          devices = [
            "Nothing 3A"
            "Citadel"
          ];
        };
      };
    };
  };

}
