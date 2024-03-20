{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./base.nix
      ];
      services.cloud-init = {
        enable = true;
        network.enable = true;
      };

      environment.systemPackages = with pkgs; [
        parted
      ];
}
