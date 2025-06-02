{
  lib,
  fetchFromGitHub,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-aMFK4verIdijgunVmj+Ge5XZZir38PLAKWNw4mOieiM=";
  };

  patches = [ ./add-Cargo.lock.patch ];

  buildAndTestSubdir = "pyrefly";
  cargoRoot = "pyrefly";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src patches;
    hash = "sha256-UkH2u+tVT4mqhrEltLbPJkxxd0P21uoDjjctuQyjHfY=";
  };

  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cybardev ];
  };
})
