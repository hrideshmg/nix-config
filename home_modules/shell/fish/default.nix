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
          set RUNTIME_DIR (mktemp -d)
          mkdir -p "$RUNTIME_DIR/"{skills,agents}
          cp -rL ~/.claude/skills/* "$RUNTIME_DIR/skills/" 2>/dev/null; or true
          cp -rL ~/.claude/agents/* "$RUNTIME_DIR/agents/" 2>/dev/null; or true
          mkdir -p "$PWD/.claude"

          printf '%s\n' \
            '#!/usr/bin/env bash' \
            'input=''$(cat)' \
            'model=''$(echo "''$input" | jq -r ".model.display_name // \"claude\"")' \
            'dir=''$(echo "''$input" | jq -r ".workspace.current_dir // \"\"")' \
            'cost=''$(echo "''$input" | jq -r ".cost.total_cost_usd // 0")' \
            'pct=''$(echo "''$input" | jq -r ".context_window.used_percentage // 0" | cut -d. -f1)' \
            'duration_ms=''$(echo "''$input" | jq -r ".cost.total_duration_ms // 0")' \
            'cyan="\033[36m"; green="\033[32m"; yellow="\033[33m"; red="\033[31m"; reset="\033[0m"' \
            'if [ "''$pct" -ge 90 ]; then bar_color="''$red"' \
            'elif [ "''$pct" -ge 70 ]; then bar_color="''$yellow"' \
            'else bar_color="''$green"; fi' \
            'filled=''$((pct / 10)); empty=''$((10 - filled))' \
            'printf -v fill "%''${filled}s"; printf -v pad "%''${empty}s"' \
            'bar="''${fill// /█}''${pad// /░}"' \
            'mins=''$((duration_ms / 60000)); secs=''$(((duration_ms % 60000) / 1000))' \
            'branch=""' \
            'git rev-parse --git-dir > /dev/null 2>&1 && branch=" | 🌿 ''$(git branch --show-current 2>/dev/null)"' \
            'echo -e "''${cyan}[''$model]''${reset} 📁 ''$(basename "''$dir")''$branch"' \
            'cost_fmt=''$(printf "\''$%.2f" "''$cost")' \
            'echo -e "''${bar_color}''${bar}''${reset} ''${pct}% | ''${yellow}''${cost_fmt}''${reset} | ''${mins}m ''${secs}s"' \
            > "$PWD/.claude/statusline.sh"
          chmod +x "$PWD/.claude/statusline.sh"

          printf '%s\n' \
            '{' \
            '  "showThinkingSummaries": true, ' \
            '  "statusLine": {' \
            '    "type": "command",' \
            '    "command": "$PWD/.claude/statusline.sh",' \
            '    "padding": 0' \
            '  },' \
            '  "modelOverrides": {' \
            '    "claude-opus-5": "arn:aws:bedrock:ap-south-1:233896339929:application-inference-profile/6iokgd5wzjbi",' \
            '    "claude-opus-4-8": "arn:aws:bedrock:ap-south-1:233896339929:application-inference-profile/tj9k6gufllq3",' \
            '    "claude-fable-5": "arn:aws:bedrock:ap-south-1:233896339929:application-inference-profile/o7s40nvrp1fd"' \
            '  }' \
            '}' \
            > "$PWD/.claude/settings.local.json"

          docker run -it --rm \
            -e HOME=/home/node \
            -e FIRECRAWL_API_KEY=${secrets.firecrawl.api_key} \
            -e CLAUDE_CODE_USE_BEDROCK=1 \
            -e AWS_BEARER_TOKEN_BEDROCK=${secrets.claude.bedrock_key} \
            -e AWS_REGION=ap-south-1 \
            -e ANTHROPIC_MODEL=arn:aws:bedrock:ap-south-1:233896339929:application-inference-profile/egja0o2rpmxq \
            -e IS_SANDBOX=1 \
            -v "$PWD:$PWD" \
            -v claude-code-state:/home/node \
            -v ~/.claude/projects:/home/node/.claude/projects \
            -v "$RUNTIME_DIR/skills:/home/node/.claude/skills:ro" \
            -v "$RUNTIME_DIR/agents:/home/node/.claude/agents:ro" \
            -w "$PWD" \
            hrideshmg/claudebox \
            npx -y @anthropic-ai/claude-code --dangerously-skip-permissions

          rm -rf "$RUNTIME_DIR"
        '';
      };
    };
    shellInit = builtins.readFile ./init.fish;
    interactiveShellInit =
      builtins.readFile ./interactive.fish + builtins.readFile ../../../secrets/ssh_servers.fish;
  };
}
