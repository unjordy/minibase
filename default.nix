{ stdenvNoCC, lib, makeWrapper, openscad }:

stdenvNoCC.mkDerivation {
  name = "minibase";
  src = ./.;
  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    openscad
  ];

  configurePhase = ''
    patchShebangs scripts/make-targets.sh
  '';

  installPhase = ''
    mkdir -p $out
    cp -r out/* $out
  '';
}
