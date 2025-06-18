{
  lib,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-RlGBo1RtHvmHCPhqV29eefm3Vgi6woi6CUBwBs63Yb0=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-akCsy3BZFquUxSt4jSEdNrHvsp6+GoegAUB1Udf2sRs=";

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
