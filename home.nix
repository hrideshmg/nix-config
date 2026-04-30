{ config, pkgs, ... }:

{
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
	];

	programs.foot = {
		enable = true;
		settings = {
			main = {
				font = "Iosevka NFM:size=14";
			};
			colors = {
				background = "2B2E37";
			};
		};
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
