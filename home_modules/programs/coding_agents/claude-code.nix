{ secrets, pkgs, ... }:
let
  statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [
      pkgs.jq
      pkgs.git
    ];
    text = ''
      input=$(cat)

      MODEL=$(echo "$input" | jq -r '.model.display_name')
      DIR=$(echo "$input" | jq -r '.workspace.current_dir')
      COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
      PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
      DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

      CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

      # Pick bar color based on context usage
      if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
      elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
      else BAR_COLOR="$GREEN"; fi

      FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
      printf -v FILL "%''${FILLED}s"; printf -v PAD "%''${EMPTY}s"
      BAR="''${FILL// /█}''${PAD// /░}"

      MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

      BRANCH=""
      git rev-parse --git-dir > /dev/null 2>&1 && BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"

      echo -e "''${CYAN}[$MODEL]''${RESET} 📁 ''${DIR##*/}$BRANCH"
      COST_FMT=$(printf "$%.2f" "$COST")
      echo -e "''${BAR_COLOR}''${BAR}''${RESET} ''${PCT}% | ''${YELLOW}''${COST_FMT}''${RESET} | ''${MINS}m ''${SECS}s"
    '';
  };
in
{
  programs.claude-code = {
    enable = true;
    agents = {
      researcher = ./agents/researcher-claude.md;
    };
    skills = {
      humanizer = ./skills/humanizer;
    };
    settings = {
      env = {
        CLAUDE_CODE_USE_BEDROCK = 1;
        AWS_REGION = "ap-south-1";
        AWS_BEARER_TOKEN_BEDROCK = secrets.claude.bedrock_key;
        ANTHROPIC_DEFAULT_OPUS_MODEL = "arn:aws:bedrock:ap-south-1:233896339929:application-inference-profile/tj9k6gufllq3";
      };
      showThinkingSummaries = true;
      statusLine = {
        type = "command";
        command = "${statusline}/bin/claude-statusline";
      };
      effortLevel = "medium";
      model = "arn:aws:bedrock:ap-south-1:233896339929:application-inference-profile/egja0o2rpmxq";
      hooks = {
        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = "notify-send 'Claude Code' 'Session Completed'";
              }
            ];
          }
        ];
        Notification = [
          {
            hooks = [
              {
                type = "command";
                command = "notify-send 'Claude Code' 'Has A Question'";
              }
            ];
          }
        ];
      };
    };
    context = ./role.md;
  };
}
