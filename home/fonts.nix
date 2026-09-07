{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
