{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation rec {
  pname = "gather-v2";
  version = "0.66.2";

  # Resolved from https://api.v2.gather.town/api/v2/releases/latest/macos/v2.
  src = fetchurl {
    url = "https://downloads.gather.town/desktop-v2/GatherV2-${version}-universal.dmg";
    hash = "sha256-6wI6dh6qy+Yi02qKwfSlDdcA0gJ2z0vCWx+fCEu94tI=";
  };

  nativeBuildInputs = [ _7zz ];
  sourceRoot = "GatherV2 ${version}-universal";
  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R GatherV2.app "$out/Applications/"
    runHook postInstall
  '';

  meta = {
    description = "Gather 2.0 desktop app for virtual workspaces";
    homepage = "https://www.gather.town/download";
    mainDarwinApp = "GatherV2.app";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
