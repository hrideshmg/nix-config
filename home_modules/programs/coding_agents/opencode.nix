{ ... }:
{
  programs.opencode = {
    enable = true;
    agents = {
      researcher = ./agents/researcher-opencode.md;
    };
    settings = {
      small_model = "azure/gpt-5.4-mini";
      plugin = [ "@mohak34/opencode-notifier@latest" ];
    };
  };
  home.file.".config/opencode/AGENTS.md" = {
    source = ./role.md;
  };

  home.sessionVariables = {
    AZURE_RESOURCE_NAME = "hridesh-foundry";
  };
}
