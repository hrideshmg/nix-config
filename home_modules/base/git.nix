{
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.gh ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "hridesh699@gmail.com";
        name = "Hridesh MG";
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
      ".aider*"
      "mprocs.yaml"
      ".envrc"
      ".env"
    ];
  };
}
