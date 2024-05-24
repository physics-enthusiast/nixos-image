{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      environment.noXlibs = false;
      services.xserver = {
        enable = true;
        desktopManager = {
          lxqt.enable = true;
        };
      };
      services.udisks2.enable = lib.mkForce false;
}
