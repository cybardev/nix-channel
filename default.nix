{ lib, callPackage, ... }:
lib.packagesFromDirectoryRecursive {
  inherit callPackage;
  directory = ./pkgs;
}
