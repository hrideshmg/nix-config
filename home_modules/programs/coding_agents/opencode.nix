{ ... }:
{
  programs.opencode = {
    enable = true;
    agents = {
      researcher = ./agents/researcher-opencode.md;
    };
    settings = {
      small_model = "github-copilot/gpt-5.4-mini";
      plugin = [ "@mohak34/opencode-notifier@latest" ];
    };
  };
  home.file.".config/opencode/AGENTS.md" = {
    source = ./role.md;
  };
}
