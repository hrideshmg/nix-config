{
  config,
  pkgs,
  username,
  ...
}:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = username;
    dataDir = "/home/${username}";
    settings = {
      devices = {
        "Nothing 3A" = {
          id = "FI75FLT-7QXDIOE-SXNJFUR-4NL5DKY-WV4FKIJ-TZVUNHW-WJ3A262-6QY5FQX";
        };
      };
      folders = {
        "obsidian" = {
          path = "/home/operator/documents/obsidian-vault";
          devices = [ "Nothing 3A" ];
        };
        "keepass_sync" = {
          path = "/home/operator/documents/keepass_sync";
          devices = [ "Nothing 3A" ];
        };
        "college" = {
          path = "/home/operator/college";
          devices = [ "Nothing 3A" ];
        };
      };
    };
  };

}
