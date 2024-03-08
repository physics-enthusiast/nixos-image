{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... }: {
    nixosModules.customFormats = {config, lib, ...}: {
      formatConfigs.azure = {config, lib, ...}: {
        fileExtension = ".vhd";
      };

      formatConfigs.docker = {config, lib, ...}: {
        services.resolved.enable = false;
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
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-generators.nixosModules.all-formats
        self.nixosModules.customFormats
        ./configuration.nix
      ];
    };
  };
}
