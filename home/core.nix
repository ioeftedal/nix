{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  home.packages = with pkgs; [
    git
    git-get
    btop
    fetch
    eza
    bat
    fzf
    ripgrep
    tree
    wget
  ];

  programs.direnv.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = vars.username;
        email = vars.email;
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      diff.algorithm = "histogram";
    };
  };

  programs.bash = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.bash}/bin/bash";
    extraConfig = ''
      set -g mouse on
      set -g history-limit 10000
    '';
  };

}
