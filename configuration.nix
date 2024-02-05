{ lib, config, pkgs, modulesPath, ... }: {
      nixpkgs.hostPlatform = "x86_64-linux";
      imports = [
        "${modulesPath}/profiles/qemu-guest.nix"
      ];

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      networking = {
        hostName = "nixos";
      };

      services.openssh.enable = true;

      services.qemuGuest.enable = true;

      security.sudo.wheelNeedsPassword = false;

      users.users.nixos = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      networking.useNetworkd= true;

      systemd.network.enable = true;

      services.cloud-init = {
        enable = true;
        network.enable = true;
      };
}
