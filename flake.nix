{
  description = "Custom vim";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              customVim = prev.vim_configurable.overrideAttrs (oldAttrs: {
                pname = "custom-vim";
                configureFlags =
                  (oldAttrs.configureFlags)
                  ++ [
                    "--with-x=yes"
                    "--disable-gui"
                  ];
                buildInputs =
                  (oldAttrs.buildInputs)
                  ++ [
                    final.xorg.libX11
                  ];
              });
            })
          ];
        };
      in {
        packages = rec {
          customVim = pkgs.customVim;
          default = customVim;
        };
        devShells.default = pkgs.mkShell {
          packages = [pkgs.customVim];
        };
      }
    );
}
