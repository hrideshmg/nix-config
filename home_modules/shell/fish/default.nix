{ secrets, ... }:

{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      vim = "nvim";
      cdr = "cd (git rev-parse --show-toplevel)";

      dev = "tmux new-session -s dev nvim";
      devt = "tmux attach -t dev";
    };

    functions = {
      de = {
        description = "docker exec -it <container> bash";
        body = ''
          docker exec -it $argv[1] bash
        '';
      };
      claudebox = {
        description = "Run Claude Code dangerously in a docker container";
        body = ''
          # Create a transient staging directory
          set RUNTIME_DIR $(mktemp -d)
          mkdir -p "$RUNTIME_DIR/"{skills,agents}

          cp -rL ~/.claude/skills/* "$RUNTIME_DIR/skills/" 2>/dev/null || true
          cp -rL ~/.claude/agents/* "$RUNTIME_DIR/agents/" 2>/dev/null || true

          docker run -it --rm \
            --user node \
            --cap-drop=ALL \
            --security-opt=no-new-privileges \
            -e CLAUDE_CODE_USE_BEDROCK=1 \
            -e AWS_BEARER_TOKEN_BEDROCK=${secrets.claude.bedrock_key} \
            -e AWS_REGION=ap-south-1 \
            -e ANTHROPIC_MODEL=global.anthropic.claude-sonnet-4-6 \
            -v "$PWD:$PWD" \
            -v claude-code-state:/home/node \
            -v ~/.claude/projects:/home/node/.claude/projects \
            -v "$RUNTIME_DIR/skills:/home/node/.claude/skills:ro" \
            -v "$RUNTIME_DIR/agents:/home/node/.claude/agents:ro" \
            -w "$PWD" \
            node:22-slim \
            npx -y @anthropic-ai/claude-code --dangerously-skip-permissions

            # Clean up the transient directory when Claude exits
            rm -rf "$RUNTIME_DIR"
        '';
      };
    };

    shellInit = builtins.readFile ./init.fish;
    interactiveShellInit =
      builtins.readFile ./interactive.fish + builtins.readFile ../../../secrets/ssh_servers.fish;
  };

}
