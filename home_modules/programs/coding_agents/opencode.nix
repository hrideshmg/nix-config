{ ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      small_model = "github-copilot/gpt-5.4-mini";
    };
  };
}
