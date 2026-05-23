{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      services.xserver = {
        enable = true;
        desktopManager = {
          lxqt.enable = true;
        };
      };
      services.udisks2.enable = lib.mkForce false;
      users.users.root.password = "nixos";
}
