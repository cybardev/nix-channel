{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
}:

let
  author = "cybardev";
  pname = "ytgo";
  version = "3.2.0";
in
buildGoModule {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = author;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kIroOjeWPi6jpW/Vpd8B5batcyOaJn9PqySp9//TCm8=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  vendorHash = "sha256-0knQiX4FkI7ujgUgpvxCubU+g+ZE3u1s6eBL13cvobQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  # checks fail cuz needs internet
  doCheck = false;
  # tests run in project repo pipeline

  postFixup = with pkgs; ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          yt-dlp
          mpv
        ]
      }
  '';

  meta = {
    description = "A Go program to find and watch YouTube videos from the terminal without requiring API keys";
    homepage = "https://github.com/${author}/${pname}";
    license = lib.licenses.gpl3Only;
    mainProgram = pname;
    platforms = lib.platforms.all;
  };
}
