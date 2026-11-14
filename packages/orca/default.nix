{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "orca";
  version = "1.4.258";

  src = fetchurl {
    url = "https://github.com/stablyai/orca/releases/download/v${version}/Orca-${version}-arm64-mac.zip";
    hash = "sha256-bswAbz8tJTHD8mNLpNEThis+5ypyXtY6ybG389c6U0Y=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";
  strictDeps = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R Orca.app "$out/Applications/"
    runHook postInstall
  '';

  meta = {
    description = "Agent development environment for parallel coding agents";
    homepage = "https://orca.dev/";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainDarwinApp = "Orca.app";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
