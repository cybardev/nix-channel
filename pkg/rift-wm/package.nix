{
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift-wm";
  version = "0.8.1-unstable-2026-11-11";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    rev = "c4551653f0e46b59538c7faac4432ef7392ac0dc";
    hash = "sha256-ootKxOaSNqq2MX9PGz9CXst00cEvKBeVJOM9Y9XhLqU=";
  };

  nativeBuildInputs = [
    apple-sdk
  ];

  cargoHash = "sha256-AgHR8thBePobjqe2r4H53m6W0b6GEI5V7BK+gjDdU9A=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macos";
    homepage = "https://github.com/acsandmann/rift";
    changelog = "https://github.com/acsandmann/rift/commits/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      eveeifyeve
      cybardev
    ];
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
})
