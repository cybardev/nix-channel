{
  lib,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-zoq6T76L2tNOPG7lJ3IhFiCr6bfdrOvRWyUaix1Uxo4=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-e2LCAYXgmrFbSrf5Gzgj1Pwhw44KqzNs7vpKxdTIj2k=";

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
