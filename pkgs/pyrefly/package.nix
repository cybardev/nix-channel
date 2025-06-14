{
  lib,
  fetchFromGitHub,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    # tag = finalAttrs.version;
    rev = "d578f98ff7c9cb35f6d153f1a072017a87835487";
    hash = "sha256-WJ1wbCH2uOadGDgPXx7g2tDwBK+by99luE1XcVieshQ=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-6eIU8kzV3tjKe8o+aIfTcv7zp7yL77MqMKttPlEx/R4=";

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
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
