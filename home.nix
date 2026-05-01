{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nvim-pkg.homeModules.default # import the HM module from the nvim flake
  ];

  home.username = "hridesh";
  home.homeDirectory = "/home/hridesh";

  home.packages = with pkgs; [
    neofetch
    firefox
    tmux
    stremio-linux-shell
    obsidian
    mpv
    nix-index
    wl-clipboard
    opencode
    python3
    rofimoji
    networkmanager_dmenu
    grimblast
    pavucontrol
    nemo-with-extensions
    vivid
    docker
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };

  nvim.enable = true;

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
    };

    shellInit = ''
      set -gx EDITOR nvim
    '';

    interactiveShellInit = ''
      set -g fish_prompt_pwd_dir_length 0

      # Disable Greeting
      set -g fish_greeting

      set -gx LS_COLORS (vivid generate snazzy)

      # Color Scheme (adapted from Nord)
      set -g fish_color_normal normal
      set -g fish_color_command 5fd7d7
      set -g fish_color_keyword 81a1c1
      set -g fish_color_quote 87d787
      set -g fish_color_redirection b48ead --bold
      set -g fish_color_end 81a1c1
      set -g fish_color_error d70000
      set -g fish_color_param d8dee9
      set -g fish_color_comment 4c566a --italics
      set -g fish_color_selection d8dee9 --bold --background=434c5e
      set -g fish_color_search_match --bold --background=434c5e
      set -g fish_color_history_current e5e9f0 --bold
      set -g fish_color_operator 81a1c1
      set -g fish_color_escape ebcb8b
      set -g fish_color_cwd 5e81ac
      set -g fish_color_cwd_root bf616a
      set -g fish_color_option 8fbcbb
      set -g fish_color_valid_path --underline=single
      set -g fish_color_autosuggestion 4c566a
      set -g fish_color_user a3be8c
      set -g fish_color_host a3be8c
      set -g fish_color_host_remote ebcb8b
      set -g fish_color_history_current e5e9f0 --bold
      set -g fish_color_status bf616a
      set -g fish_color_cancel --reverse
      set -g fish_pager_color_prefix normal --bold --underline=single
      set -g fish_pager_color_progress 3b4252 --bold --background=d08770
      set -g fish_pager_color_completion e5e9f0
      set -g fish_pager_color_description ebcb8b --italics
      set -g fish_pager_color_selected_background --background=434c5e
      set -g fish_pager_color_secondary_completion 
      set -g fish_pager_color_selected_prefix 
      set -g fish_pager_color_secondary_description 
      set -g fish_pager_color_secondary_background 
      set -g fish_pager_color_background 
      set -g fish_pager_color_selected_description 
      set -g fish_pager_color_secondary_prefix 
      set -g fish_pager_color_selected_completion

      # build git prompt
      set -g __fish_git_prompt_showdirtystate 1
      set -g __fish_git_prompt_showuntrackedfiles 1
      set -g __fish_git_prompt_showcolorhints 1
      set -g __fish_git_prompt_use_informative_chars 1

      set -g __fish_git_prompt_color_prefix 949494
      set -g __fish_git_prompt_color_suffix 949494

      set -g __fish_git_prompt_char_dirtystate ''
      set -g __fish_git_prompt_char_invalidstate ''
      set -g __fish_git_prompt_char_stagedstate ''
      set -g __fish_git_prompt_char_untrackedfiles '󰐙'

      set -g __fish_git_prompt_color_dirtystate yellow
      set -g __fish_git_prompt_color_invalidstate red
      set -g __fish_git_prompt_color_stagedstate green
      set -g __fish_git_prompt_color_untrackedfiles cyan

      # build main prompt
      function fish_prompt
        set -l cyan (set_color 5fd7ff)
        set -l reset (set_color normal)
        set -l pwd_str "$cyan"(prompt_pwd)"$reset"
        set -l git_str (fish_git_prompt " (%s)")
        echo -n "$pwd_str$git_str -> "
      end
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka NFM:size=14";
      };
      colors = {
        background = "2B2E37";
        cursor = "2B2E37 FFFFFF";
      };
    };
  };

  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
    plugins = with pkgs; [
      rofi-calc
    ];
  };

  programs.tmux = {
    enable = true;

    shortcut = "space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      		      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      		      set-option -g renumber-windows on
      		      unbind C-/

      		      # If only 1 pane, split it. If zoomed, unzoom. If multiple panes, toggle zoom.
      		      bind -n 'M-\' if-shell '[ "$(tmux list-panes | wc -l)" = 1 ]' 	\
      			'split-window -v -c "#{pane_current_path}" -l 25%'		\
      			'if-shell "[ -n \"$(tmux list-panes -F '''#F''' | grep Z)\" ]"	\
      			 "resize-pane -t1 -Z; select-pane -t2"				\
      			 "resize-pane -Z -t1"'

      		      # Window Navigation
      		      bind -n M-h previous-window
      		      bind -n M-l next-window

      		      # Quick Window Selection
      		      bind -n M-1 select-window -t 1
      		      bind -n M-2 select-window -t 2
      		      bind -n M-3 select-window -t 3
      		      bind -n M-4 select-window -t 4
      		      bind -n M-5 select-window -t 5

      		      # Splits and Session Management
      		      bind - split-window -v -c "#{pane_current_path}"
      		      bind \\ split-window -h -c "#{pane_current_path}"
      		      bind x kill-pane
      		      bind X kill-session
      		      set -g pane-active-border-style 'fg=#698DDA'

      		      # Pane Resizing (Prefix + Ctrl + hjkl)
      		      bind -r C-j resize-pane -D 2
      		      bind -r C-k resize-pane -U 2
      		      bind -r C-h resize-pane -L 2
      		      bind -r C-l resize-pane -R 2
      		    '';

    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      minimal-tmux-status
      sensible
      yank
      vim-tmux-navigator
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "hridesh699@gmail.com";
        name = "Hridesh MG";
        signingkey = "85C0EF6C72674D7B";
      };
      signing.signByDefault = false;
      alias = {
        co = "checkout";
        cm = "commit -m";
        ca = "commit -am";
        st = "status";
        br = "branch";
        fp = "push --force";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        hotfix = "commit --amend --no-edit -a";
        pushremote = "!git push $(git config --get branch.$(git symbolic-ref HEAD --short).pushRemote) +@:$(git config --get branch.$(git symbolic-ref HEAD --short).merge | awk -F / '{print $NF}')";
      };
      core.editor = "nvim";
      push.autoSetupRemote = true;
      safe.directory = [
        "/etc/nixos"
      ];
      commit.gpgsign = false;
      tag.gpgsign = false;
      pull.rebase = true;
    };
    ignores = [
      ".in"
      ".out"
      ".aider*"
      "mprocs.yaml"
    ];
  };

  services.wayvnc = {
    enable = true;
    autoStart = true;
    settings.address = "0.0.0.0";
    settings.port = 5900;
  };

  home.stateVersion = "25.11";
}
