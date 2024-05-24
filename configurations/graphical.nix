{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];
      # the container configurations default this to true
      environment.noXlibs = false;
      services.xserver = {
        enable = true;
        desktopManager = {
          lxqt.enable = true;
        };
      };
      services.udisks2.enable = lib.mkForce false;
      users.users.root.password = "nixos";
}
