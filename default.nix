{ pkgs, ... }:
{
  cutefetch = pkgs.callPackage ./pkgs/cutefetch { };
  freej2me = pkgs.callPackage ./pkgs/freej2me { };
  jitterbugpair = pkgs.callPackage ./pkgs/jitterbugpair { };
  logseq = pkgs.callPackage ./pkgs/logseq { };
  ytgo = pkgs.callPackage ./pkgs/ytgo { };
}
