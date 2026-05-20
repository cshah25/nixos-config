{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra = ''
      # Sourcing the p10k configuration file
      source ${./dotfiles/p10k.zsh}

      pybox() {
        if [[ -z "$1" ]]; then
            echo "Error: No target directory provided."
            echo "Usage: pybox <path-to-project-folder>"
            return 1
        fi
        local target_dir="$1"
        distrobox enter python312-box -- bash -c "cd $target_dir && source .venv/bin/activate && exec bash"
      }
    '';
  };
}
