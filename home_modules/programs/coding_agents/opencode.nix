{ secrets, ... }:
{
  programs.opencode = {
    enable = true;
    context = ./nixos-apps.md;
    settings = {
      model = "azure/gpt-6-luna";
      small_model = "azure/gpt-6-luna";
      plugin = [ "@mohak34/opencode-notifier@latest" ];
      permission = {
        websearch = "allow";
      };
      mcp = {
        exa = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp";
          enabled = true;
          headers = {
            "x-api-key" = secrets.exa.api_key;
          };
        };
        firecrawl = {
          type = "remote";
          url = "https://mcp.firecrawl.dev/v2/mcp";
          enabled = true;
          oauth = false;
          headers = {
            Authorization = "Bearer ${secrets.firecrawl.api_key}";
          };
        };
        nixos = {
          type = "local";
          command = [ "mcp-nixos" "--" ];
          enabled = true;
        };
      };
    };
  };

  home.sessionVariables = {
    AZURE_RESOURCE_NAME = "hridesh-foundry";
    AWS_REGION = "ap-south-1";
    OPENCODE_ENABLE_EXA = "1";
  };
}
