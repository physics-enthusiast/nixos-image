{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      services.cloud-init = {
        enable = true;
        network.enable = true;
      };
}
