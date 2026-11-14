{
  stdenv,
  lib,
  fetchurl,
  cataclysm-dda,
  undmg,
  makeWrapper,
}:
{
  makeCddaPackage = (
    {
      pname,
      version,
      timestamp,
      hash,
    }:
    let
      appName = "Cataclysm.app";
    in
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version;

      src = fetchurl {
        url = "https://github.com/CleverRaven/Cataclysm-DDA/releases/download/${finalAttrs.version}/cdda-osx-with-graphics-universal-${timestamp}.dmg";
        inherit hash;
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
  );
}
