{ lib, config, pkgs, modulesPath, ... }: {
      imports = [
        ./nocloud.nix
      ];

      services.xserver = {
        enable = true;
        windowManager.openbox.enable = true;
        displayManager.sddm.enable = true;
      };
      services.picom.enable = true;

      environment = {
        systemPackages = with pkgs; [
          tint2
          xterm
          feh
          volumeicon
        ];
        etc = {
          "xdg/openbox/autostart" = {
            text = ''
              tint2 &
              volumeicon &
            '';
          };
        };
      };

      programs.thunar.enable = true;
      programs.nm-applet.enable = true;

      users.users.root.password = "nixos";
}
