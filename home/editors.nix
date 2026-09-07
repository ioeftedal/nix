{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gnumake
    neovim
    pkg-config
    tree-sitter
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs.lazygit.enable = true;
}
