{ lib, config, pkgs, modulesPath, ... }: {
      #https://bugs.launchpad.net/cirros/+bug/1312199
      boot.kernelParams = [ "no_timer_check" ];

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      networking = {
        hostName = "nixos";
      };

      services.openssh.enable = true;

      security.sudo.wheelNeedsPassword = false;

      users.users.nixos = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      networking.useNetworkd= lib.mkDefault true;

      systemd.network.enable = lib.mkDefault true;

      environment.systemPackages = with pkgs; [
        parted
      ];
}  
