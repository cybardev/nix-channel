{ pkgs, ... }:
let
  python = pkgs.python313;
  pythonPackages = pkgs.python313Packages;
  pycord =
    let
      pname = "py_cord";
      version = "2.6.2";
    in
    pythonPackages.buildPythonPackage {
      pyproject = true;
      build-system = with pythonPackages; [
        setuptools
        setuptools-scm
      ];
      doCheck = false;
      inherit pname version;
      src = pkgs.fetchFromGitHub {
        owner = "Pycord-Development";
        repo = "pycord";
        rev = "bc287f4f9286646151017296b9ba431728381b18";
        hash = "sha256-084VAx1b+0U7zSKDnS2kf8M6BAL9yGjpTGhk/q3QGcg=";
      };
      propagatedBuildInputs = with pythonPackages; [
        aiohttp
        faust-cchardet
        msgspec
        typing-extensions
        yarl
      ];
    };
  ytgo = pkgs.callPackage ../ytgo/package.nix { };
in
python.pkgs.buildPythonApplication rec {
  pname = "ytgo-bot";
  version = "1.2.1";
  pyproject = true;
  build-system = [ pythonPackages.setuptools ];
  propagatedBuildInputs = [
    pycord
    (ytgo.overrideAttrs (
      finalAttrs: previousAttrs: {
        postFixup = "";
      }
    ))
  ];
  src = pkgs.fetchFromGitHub {
    owner = "cybardev";
    repo = "ytgo-bot";
    tag = "v${version}";
    hash = "sha256-K+EQXZZAwsQKccTjSTYG6/b2hmxfRr1rZ2HFOUJhElc=";
  };
  meta.mainProgram = "ytgo-bot.py";
}
