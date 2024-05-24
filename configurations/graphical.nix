{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      nixpkgs.overlays = [ (
        final: prev: {
          openbox = prev.openbox.overrideAttrs (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ [ pkgs.pango.dev ];
          };
        }
      ) ];
      services.xserver = {
        enable = true;
        desktopManager = {
          lxqt.enable = true;
        };
      };
}
