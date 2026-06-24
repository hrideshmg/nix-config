{ ... }:
{
  programs.zathura = {
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      selection-notification = false;
      scroll-page-aware = true;
      zoom-step = 20;
      scroll-step = 100;
      adjust-open = "best-fit";

      # zathurarc-dark
      font = "inconsolata 15";
      default-bg = "#181a1f";
      default-fg = "#F7F7F6";
      statusbar-fg = "#B0B0B0";
      statusbar-bg = "#202020";
      inputbar-bg = "#151515";
      inputbar-fg = "#FFFFFF";
      notification-error-bg = "#AC4142";
      notification-error-fg = "#151515";
      notification-warning-bg = "#AC4142";
      notification-warning-fg = "#151515";
      # highlight-color = "#458566";
      # highlight-active-color = "#F4BF75";
      completion-highlight-fg = "#151515";
      completion-highlight-bg = "#90A959";
      completion-bg = "#303030";
      completion-fg = "#E0E0E0";
      notification-bg = "#90A959";
      notification-fg = "#151515";

      recolor = true;
      recolor-lightcolor = "#181a1f";
      recolor-darkcolor = "#ffffff";
      recolor-reverse-video = true;
      recolor-keephue = true;
    };

    mappings = {
      i = "recolor";
      z = "toggle_statusbar";
      "<C-=>" = "zoom in";
      "<C-->" = "zoom out";
      "<C-u>" = "navigate previous";
      "<C-d>" = "navigate next";
      u = "scroll half-up";
      d = "scroll half-down";
    };

    extraConfig = ''
      unmap =
      unmap -
    '';
  };
}
