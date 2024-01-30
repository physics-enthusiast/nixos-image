{ lib, config, pkgs, ...}: {
      nixpkgs.hostPlatform = "x86_64-linux";
      imports = [
        "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
      ];

      networking = {
        hostName = "nixos-cloudinit";
      };

      fileSystems."/" = {
        label = "nixos";
        fsType = "ext4";
        autoResize = true;
      };
      boot.loader.grub.device = "/dev/sda";

      services.openssh.enable = true;

      services.qemuGuest.enable = true;

      security.sudo.wheelNeedsPassword = false;

      users.users.ops = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      networking = {
        defaultGateway = { address = "10.1.1.1"; interface = "eth0"; };
        dhcpcd.enable = false;
        interfaces.eth0.useDHCP = false;
      };

      systemd.network.enable = true;

      services.cloud-init = {
        enable = true;
        network.enable = true;
        config = ''
          system_info:
            distro: nixos
            network:
              renderers: [ 'networkd' ]
            default_user:
              name: ops
          users:
              - default
          ssh_pwauth: false
          chpasswd:
            expire: false
          cloud_init_modules:
            - migrator
            - seed_random
            - growpart
            - resizefs
          cloud_config_modules:
            - disk_setup
            - mounts
            - set-passwords
            - ssh
          cloud_final_modules: []
          '';
      };
}
