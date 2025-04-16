{
  description = "cybardev/nix-channel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    {
      legacyPackages = forAllSystems (
        pkgs:
        let
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
        cy = final.callPackage ./. { };
      };
    };
}
