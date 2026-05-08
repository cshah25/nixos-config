{ config, pkgs, ... }:

{
  xdg.configFile = {
	 "alacritty".source = ./dotfiles/alacritty;
	 "gtk-3.0".source = ./dotfiles/gtk-3.0;
	 "gtk-4.0".source = ./dotfiles/gtk-4.0;
	 "Kvantum".source = ./dotfiles/Kvantum;
	 "niri".source = ./dotfiles/niri;
	 "qt5ct".source = ./dotfiles/qt5ct;
   "nvim".source = ./dotfiles/nvim;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
    };
  };

  dconf.enable = true;
  gtk.enable = true;

  programs.zsh = {
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
      # Sourcing the p10k configuration file if it exists
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      pybox() {
        # Check if the first argument ($1) is empty
        if [[ -z "$1" ]]; then
            echo "Error: No target directory provided."
            echo "Usage: pybox <path-to-project-folder>"
            return 1
        fi

        local target_dir="$1"

        # Enter the box, change directory, activate the venv, and keep the shell open
        distrobox enter python312-box -- bash -c "cd $target_dir && source .venv/bin/activate && exec bash"
      }
    '';
  };
}
