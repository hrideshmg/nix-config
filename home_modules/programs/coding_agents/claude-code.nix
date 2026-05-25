{ ... }:
{
  programs.claude-code = {
    enable = true;
    skills = {
      humanizer = ./skills/humanizer;
    };
  };
}
