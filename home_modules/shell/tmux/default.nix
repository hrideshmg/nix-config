{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    shortcut = "space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = builtins.readFile ./tmux.conf;

    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      minimal-tmux-status
      sensible
      yank
      vim-tmux-navigator
    ];
  };
}
