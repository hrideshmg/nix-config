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
        "Workstation" = {
          id = "RMJVGRE-ZDUEYVN-3QTXYJX-SWJ7PPI-3WE47KU-O25HWIH-23F4MWN-UECVNAL";
        };
      };
      folders = {
        "obsidian" = {
          path = "/home/${username}/documents/obsidian-vault";
          devices = [
            "Nothing 3A"
            "Workstation"
          ];
        };
        "keepass_sync" = {
          path = "/home/${username}/documents/keepass_sync";
          devices = [
            "Nothing 3A"
            "Workstation"
          ];
        };
        "college" = {
          path = "/home/${username}/college";
          devices = [
            "Nothing 3A"
            "Workstation"
          ];
        };
      };
    };
  };

}
