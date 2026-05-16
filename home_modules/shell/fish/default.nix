{ ... }:

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
    };

    shellInit = builtins.readFile ./init.fish;
    interactiveShellInit = builtins.readFile ./interactive.fish;
  };

}
