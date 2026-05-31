{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 120;
      indicator-thickness = 5;
      timestr = "%I:%M %p";

      inside-wrong-color = "f38ba8";
      ring-wrong-color = "11111b";
      inside-clear-color = "a6e3a1";
      ring-clear-color = "11111b";
      inside-ver-color = "ebf2ff";
      ring-ver-color = "2B2E37";
      text-color = "FFFFFF";
      ring-color = "2B2E37";
      key-hl-color = "DBD5C7";
      line-color = "2B2E37";
      inside-color = "11111b00";
      separator-color = "00000000";

      effect-blur = "10x7";
      effect-vignette = "0.2:0.2";
    };
  };
}
