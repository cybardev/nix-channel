{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-388XPTrLxKAnx9UAQuciIiekp6heKujHDw4leIYOpDQ=";
  };

  cargoHash = "sha256-A0huWauj3Ltnw39jFft6pyYUVcNK+lu89ZlVQl/aRZg=";

  postInstall = ''
    mkdir -p $out/share/rift
    cp $src/rift.default.toml $out/share/rift/config.toml
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macos";
    homepage = "https://github.com/acsandmann/rift";
    license = lib.licenses.asl20;
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
    ];
  };
})
