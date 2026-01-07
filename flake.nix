{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-bundle = {
      url = "github:nix-community/nix-bundle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ flake-parts.flakeModules.bundlers ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          bundlers.default =
            drv:
            let
              mkFlatPak = pkgs.callPackage ./mkFlatPak.nix {
                toArx = (inputs.nix-bundle.bundlers.${system}.default drv);
              };
            in
            if drv ? type && drv.type == "app" then
              mkFlatPak { program = drv.program; }
            else if pkgs.lib.isDerivation drv then
              mkFlatPak { program = pkgs.lib.getExe drv; }
            else
              abort "don't know how to build this; only know app and derivation";
        };
    };
}
