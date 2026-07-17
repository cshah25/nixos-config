{ config, pkgs, hostname, ... }:

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

    initContent = ''
      # Sourcing the p10k configuration file
      source $(./dotfiles/p10k.zsh)

      # Nix commands
      alias nrs='sudo nixos-rebuild switch --flake /home/rayu/nixos-config/#${hostname}'
      alias nrb='sudo nixos-rebuild boot --flake /home/rayu/nixos-config/#${hostname}'     
      alias nfu='nix flake update'
      
      # Git commands
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit -m'
      alias gp='git push'
      alias gpl='git pull'
      alias gf='git fetch'
      alias gcl='git clone'
      alias gl='git log'

      # Distrobox 
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
