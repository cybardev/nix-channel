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
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          cypkgs = import ./default.nix {
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
        cy = final.callPackage ./default.nix { };
      };

      modules = {
        opencode = ./mod/opencode;
        soft-serve = ./mod/soft-serve;
        ytgo-bot = ./mod/ytgo-bot;
        websurfx = ./mod/websurfx;
        tenere = ./mod/tenere;
      };
    };
}
