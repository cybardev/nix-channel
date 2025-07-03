{
  lib,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-8qId9X/ImbddvitzfFWn1XvQP5bMWsKczME/gjVyKS8=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-ql66BrQlsTopzfP92+Yosjx6cWmM/9Aikza1YfKlF7U=";

  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
