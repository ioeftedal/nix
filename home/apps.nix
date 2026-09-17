{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  home.packages = with pkgs; [
    opencode
  ];
}
