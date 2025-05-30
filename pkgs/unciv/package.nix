{
  stdenv,
  lib,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  zulu11,
  libGL,
  libpulseaudio,
  libXxf86vm,
}:
let
  jre = zulu11;
  version = "4.16.2";

  desktopItem = makeDesktopItem {
    name = "unciv";
    exec = "unciv";
    comment = "An open-source Android/Desktop remake of Civ V";
    desktopName = "Unciv";
    icon = "unciv";
    categories = [ "Game" ];
  };

  desktopIcon = fetchurl {
    url = "https://github.com/yairm210/Unciv/blob/${version}/extraImages/Icons/Unciv%20icon%20v4%20Simplified.png?raw=true";
    hash = "sha256-3qcFid2aSEpEJvH0ATN0wLXqDYXD9mSNJDnxlXA2NBs=";
  };

  envLibPath = lib.makeLibraryPath (
    lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      libpulseaudio
      libXxf86vm
    ]
  );

in
stdenv.mkDerivation rec {
  pname = "unciv";
  inherit version;

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-cnUiyh+fCK5CKg+Ik5TQD+weMEHqjsBEh/bOpOKoOow=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/unciv \
      --prefix LD_LIBRARY_PATH : "${envLibPath}" \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar ${src}"

    install -Dm444 ${desktopIcon} $out/share/icons/hicolor/512x512/apps/unciv.png

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Open-source Android/Desktop remake of Civ V";
    mainProgram = "unciv";
    homepage = "https://github.com/yairm210/Unciv";
    maintainers = with maintainers; [ tex ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
