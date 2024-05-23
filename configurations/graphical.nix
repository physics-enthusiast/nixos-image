{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      services.xserver.enable = true;
      services.xserver.desktopManager.lxqt.enable = true;
}
