{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./pkgs;
}
