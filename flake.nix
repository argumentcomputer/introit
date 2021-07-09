{
  description = "Introit the standard lib of Yatima";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.yatima.url = "github:yatima-inc/yatima";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils, yatima }: 
    utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      yatima-bin = yatima.apps.${system}.yatima.program;
      name = "introit";
      src = ./.;
      yatima-check = file: pkgs.runCommand "yatima-check" {
        inherit src;
        buildInputs = [ yatima ];
      } ''
        ${yatima-bin} --no-file-store --root ${src} check ${file} > $out
      '';

    in
    {
      checks.${name} = yatima-check "introit.ya";
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          yatima
        ];
      };

    });
}
