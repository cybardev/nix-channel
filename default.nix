let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super: {
        cutefetch = pkgs.callPackage ./pkgs/cutefetch;
        freej2me = pkgs.callPackage ./pkgs/freej2me;
        ytgo = pkgs.callPackage ./pkgs/ytgo;
      })
    ];
  };
in
pkgs
