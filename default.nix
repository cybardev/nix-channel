{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
lib.makeScope pkgs.newScope (
  self:
  pkgs.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./pkgs;
  }
)
