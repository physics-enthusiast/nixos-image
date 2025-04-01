{
  inputs = {
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
    };
    nixpkgs.url = "github:physics-enthusiast/nixpkgs/vbox-compress";
    #nixpkgs.follows = "nixos-generators/nixpkgs";
  };
  outputs = { self, nixpkgs, nixos-generators, ... }: let
  architectures = builtins.fromJSON (builtins.readFile ./architectures.json);
  configurations = builtins.map (filename: builtins.replaceStrings [".nix"] [""] filename) (builtins.attrNames (builtins.readDir ./configurations));
  in
  {
    nixosModules.customFormats = {config, lib, ...}: {
      formatConfigs.amazon = {config, lib, ...}: {
        amazonImage.sizeMB = "auto";
      };

      formatConfigs.do = {config, lib, ...}: {
        # https://github.com/NixOS/nixpkgs/issues/308404
        # set both, else module merge rules lead to duplicate entries in boot.loader.grub.devices
        boot.loader.grub.devices = lib.mkForce [ "/dev/vda" ];
        boot.loader.grub.device = "/dev/vda";
      };

      formatConfigs.docker = {config, lib, ...}: {
        services.resolved.enable = false;
      };

      formatConfigs.gce = {config, lib, ...}: {
        virtualisation.googleComputeImage.compressionLevel = 9;
      };

      formatConfigs.hyperv = {config, lib, ...}: {
        virtualisation.diskSize = "auto";
      };

      formatConfigs.oracle = {config, modulesPath, ...}: {
        imports = [
          "${toString modulesPath}/virtualisation/oci-image.nix"
        ];

        formatAttr = "OCIImage";
        fileExtension = ".qcow2";
      };
	  
      formatConfigs.qcow = {config, lib, ...}: {
        services.qemuGuest.enable = true;
      };
    };
    nixosConfigurations = builtins.listToAttrs (nixpkgs.lib.lists.forEach (nixpkgs.lib.attrsets.cartesianProductOfSets { architecture = architectures; configuration = configurations; }) (systemInfo: nixpkgs.lib.attrsets.nameValuePair "nixos-${systemInfo.configuration}-${systemInfo.architecture}" (nixpkgs.lib.nixosSystem {
      system = "${systemInfo.architecture}-linux";
      modules = [
        (nixpkgs.outPath + "/nixos/modules/profiles/minimal.nix")
        nixos-generators.nixosModules.all-formats
        self.nixosModules.customFormats
        (nixpkgs.lib.path.append ./configurations "${systemInfo.configuration}.nix")
      ];
    })));
  };
}
