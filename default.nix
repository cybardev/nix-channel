{ lib, callPackage, ... }:
lib.packagesFromDirectoryRecursive {
  inherit callPackage;
  directory = ./pkg;
}
