{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  rustPlatform,
  pythonOlder,
  # maturin,
}:
buildPythonApplication rec {
  pname = "pyrefly";
  version = "0.17.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    rev = version;
    hash = "";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  # propagatedBuildInputs = [
  #   maturin
  # ];

  # disable tests
  doCheck = false;

  meta = with lib; {
    description = "A fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = licenses.mit;
    maintainers = [];
  };
}
