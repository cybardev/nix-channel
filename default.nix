{
  lib,
  pkgs ? import <nixpkgs> {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "freej2me"
        ];
    };
    overlays = [ ];
  },
  ...
}:
{
  cutefetch = pkgs.callPackage ./pkgs/cutefetch { };
  freej2me = pkgs.callPackage ./pkgs/freej2me { };
  ytgo = pkgs.callPackage ./pkgs/ytgo { };
}
