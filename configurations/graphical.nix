{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];

      services = {
        displayManager.sddm = {
          enable = true;
          wayland = {
            enable = true;
            compositor = "kwin";
          };
        };
      };
      services.picom.enable = true;

      users.users.nixos.password = "nixos";
      users.users.root.password = "nixos";
}
