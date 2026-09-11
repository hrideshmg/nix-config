{ ... }:
{
  programs.opencode = {
    enable = true;
    agents = {
      researcher = ./agents/researcher-opencode.md;
    };
    settings = {
      model = "azure/gpt-5.6-terra";
      small_model = "azure/gpt-5.6-luna";
      plugin = [ "@mohak34/opencode-notifier@latest" ];
    };
  };

  home.sessionVariables = {
    AZURE_RESOURCE_NAME = "hridesh-foundry";
    AWS_REGION = "ap-south-1";
  };
}
