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
      formatConfigs.docker = {config, lib, ...}: {
        services.resolved.enable = false;
        services.qemuGuest.enable = lib.mkForce false;
      };

      formatConfigs.oracle = {config, modulesPath, ...}: {
        imports = [
          "${toString modulesPath}/virtualisation/oci-image.nix"
        ];

        formatAttr = "oracleCloudImage";
        fileExtension = ".qcow2";
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
