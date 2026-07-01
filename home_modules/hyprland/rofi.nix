{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # rofi plugins
    rofimoji
    networkmanager_dmenu
  ];

  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
    plugins = with pkgs; [
      # Add a calculator to rofi
      rofi-calc
    ];
  };

  # networkmanager_dmenu dotfile
  home.file.".config/networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi
    active_chars = ==
    highlight = True
    highlight_fg =
    highlight_bg =
    highlight_bold = True
    compact = False
    pinentry =
    wifi_icons = 󰤯󰤟󰤢󰤥󰤨
    format = {name:<{max_len_name}s}  {sec:<{max_len_sec}s} {icon:>4}
    list_saved = True
    prompt = Networks

    [dmenu_passphrase]
    obscure = False
    obscure_color = #222222

    [pinentry]
    description = Get network password
    prompt = Password:

    [editor]
    terminal = foot
    gui_if_available = True
    gui = nm-connection-editor

    [nmdm]
    rescan_delay = 5
  '';
}
