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
      };
      services.displayManager.defaultSession = "xfce";
      services.udisks2.enable = lib.mkForce false;
      users.users.root.password = "nixos";
}
