{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      services.xserver = {
        enable = true;
        desktopManager = {
          xterm.enable = false;
          xfce.enable = true;
        };
        displayManager.defaultSession = "xfce";
      };
}
