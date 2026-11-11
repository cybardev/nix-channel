{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  stripJavaArchivesHook,
  makeWrapper,
  jre8_headless,
  ant,
}:
stdenvNoCC.mkDerivation {
  pname = "freej2me";
  version = "1.52-unstable-2026-11-11";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "freej2me-plus";
    rev = "5cf0879f460580cc39a52e6b251bcba6cda39530";
    hash = "sha256-XTEi3yvg0hRoiRgXq8aOthUBzJ5uRR8I8i1Z0FdbvPc=";
  };

  nativeBuildInputs = [
    ant
    makeWrapper
    jre8_headless
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 "build/freej2me_plus.jar" "$out/share/java/freej2me_plus.jar"
    mkdir -p "$out/bin"
    makeWrapper ${lib.getExe' jre8_headless "java"} $out/bin/freej2me \
      --add-flags "-jar $out/share/java/freej2me_plus.jar"
    runHook postInstall
  '';

  meta = {
    description = "Free J2ME emulator with libretro, awt and sdl2 frontends";
    homepage = "https://github.com/TASEmulators/freej2me-plus";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    mainProgram = "freej2me";
    maintainers = with lib.maintainers; [
      cybardev
    ];
  };
}
