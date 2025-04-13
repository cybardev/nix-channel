{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

let
  author = "cybardev";
  pname = "zen.zsh";
  version = "2.0";
in
stdenvNoCC.mkDerivation {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = author;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s/YLFdhCrJjcqvA6HuQtP0ADjBtOqAP+arjpFM2m4oQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp prompt_zen_setup "$out/"
    runHook postInstall
  '';

  meta = {
    description = "Simple and Peaceful Zsh Prompt";
    homepage = "https://github.com/${author}/${pname}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
