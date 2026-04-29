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
	];

	programs.foot = {
		enable = true;
		settings = {
			main = {
				font = "monospace:size=12";
			};
		};
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
