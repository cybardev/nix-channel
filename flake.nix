{
  description = "cybardev/nix-channel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          cypkgs = import ./default.nix { inherit pkgs; };
        in
        cypkgs
        // {
          default = pkgs.symlinkJoin {
            name = "cypkgs";
            paths = builtins.filter pkgs.lib.isDerivation (builtins.attrValues cypkgs);
          };
        }
      );
    };
}
