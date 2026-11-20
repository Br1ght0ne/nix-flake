{
  stdenv,
  lib,
  fetchurl,
  cataclysm-dda,
  undmg,
  makeWrapper,
}:
let
  timestamp = "2026-11-15-1800";
  appName = "Cataclysm.app";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cataclysm-dda-bin-git";
  version = "cdda-experimental-${timestamp}";

  src = fetchurl {
    url = "https://github.com/CleverRaven/Cataclysm-DDA/releases/download/${finalAttrs.version}/cdda-osx-with-graphics-universal-${timestamp}.dmg";
    hash = "sha256-lKbA/1OiIdh3qQYHA8ycudjRJFgLdyM6Du2Y2K4q+jQ=";
  };

  nativeBuildInputs = [
    undmg
    makeWrapper
  ];

  unpackPhase = ''
    undmg $src
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R ${appName} $out/Applications/${appName}
    makeWrapper $out/Applications/${appName}/Contents/MacOS/Cataclysm.sh $out/bin/cataclysm-tiles
    runHook postInstall
  '';

  meta = cataclysm-dda.meta // {
    description = "Cataclysm: Dark Days Ahead (binary distribution)";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
  };
})
