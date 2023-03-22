{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.openscad
    pkgs.zip

    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
