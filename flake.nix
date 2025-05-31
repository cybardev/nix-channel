{
  description = "cybardev/nix-channel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    ...
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
        system:
          function (import nixpkgs {
            inherit system;
            overlays = [rust-overlay.overlays.default];
          })
      );
  in {
    legacyPackages = forAllSystems (
      pkgs: let
        cypkgs = import ./. {
          inherit (pkgs) lib callPackage;
        };
      in
        cypkgs
        // {
          default = pkgs.symlinkJoin {
            name = "cypkgs";
            paths = builtins.filter pkgs.lib.isDerivation (builtins.attrValues cypkgs);
          };
        }
    );

    overlays.default = final: prev: {
      cy = final.callPackage ./. {};
    };
  };
}
