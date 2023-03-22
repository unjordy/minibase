{
  outputs = { self, nixpkgs }:
  let
    supportedSystems = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in
  {
    packages = forAllSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    rec {
      minibase = pkgs.callPackage ./default.nix {};
      ci = pkgs.writeShellScriptBin "ci" ''
        mkdir -p archive
        cp -r ${minibase}/* archive
        chmod -R 755 archive
        zip -r -j minibase archive
        rm -r archive
      '';
      default = minibase;
    });
    defaultPackage = forAllSystems (system: self.packages.${system}.default);

    devshells = forAllSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = import ./shell.nix {inherit pkgs; };
    }
    );

    apps = forAllSystems (system:
    let
      ci = self.packages.${system}.ci;
    in
    {
      ci = {
        type = "app";
        program = "${ci}/bin/ci";
      };
    });
  };
}
