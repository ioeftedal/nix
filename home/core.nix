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
    sops
    age
    btop
    fetch
    eza
    bat
    fzf
    ripgrep
    tree
    wget
    sl
    # C toolchain: nvim-treesitter compiles its parsers with `cc`/`make` at
    # Neovim startup (fails with "No such file or directory (os error 2)" if absent).
    gcc
    gnumake
    pkg-config
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
    shellAliases = {
      ls = "eza -l --icons";
      la = "eza -la --icons";
    };
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
