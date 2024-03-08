{ lib, config, pkgs, modulesPath, ... }: {
      nixpkgs.hostPlatform = "x86_64-linux";

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

      networking.useNetworkd= true;

      systemd.network.enable = lib.mkForce true;
}
