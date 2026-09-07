{
  config,
  lib,
  pkgs,
  vars,
  ...
}: let
  sioyekPkg = pkgs.sioyek.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./sioyek-ctrl-jk-menu.patch];
  });
in {
  programs.sioyek = {
    enable = true;
    package = sioyekPkg;
    config = {
      should_launch_new_window = "1";
      show_doc_path = "1";
    };
  };
}
