{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
lib.makeScope pkgs.newScope (
  self:
  lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./pkgs;
  }
)
