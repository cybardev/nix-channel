{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  envVars ? { },
}:
buildNpmPackage (finalAttrs: {
  pname = "mirotalk";
  version = "1.5.56-unstable-2025-08-10";

  src = fetchFromGitHub {
    owner = "miroslavpejic85";
    repo = "mirotalk";
    rev = "93e3b6969e32f834f0068a410e923f309c753ec1";
    hash = "sha256-8EOsl49BstW9el1rdtpQR0z+mlhKT/tcE8CW6+ZksiQ=";
  };

  npmDepsHash = "sha256-Jq3BSGJc/9baQKnkr7l4VmB4xobSy2T7J465QOui0bs=";

  dontNpmBuild = true;

  postInstall = ''
    cp ${finalAttrs.src}/app/src/config.template.js $out/lib/node_modules/mirotalk/app/src/config.js

    makeWrapper ${lib.getExe nodejs} $out/bin/mirotalk \
      --add-flags $out/lib/node_modules/mirotalk/app/src/server.js \
      ${lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "--set ${k} ${lib.escapeShellArg v}") envVars)}
  '';

  meta = {
    description = "Free WebRTC browser-based video call";
    homepage = "https://github.com/miroslavpejic85/mirotalk";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      cybardev
    ];
  };
})
