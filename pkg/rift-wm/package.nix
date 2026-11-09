{
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift-wm";
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iGz3QRU3t0nNEvtZ/i/9LmUncCEyKWy14MkkuZVb4hQ=";
  };

  nativeBuildInputs = [ apple-sdk ];

  cargoHash = "sha256-lhOc53eMJIpdO8iPylcN6I9N5WwMTT6XhaZwh4jD6So=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macos";
    homepage = "https://github.com/acsandmann/rift";
    changelog = "https://github.com/acsandmann/rift/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      eveeifyeve
      cybardev
    ];
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
})
