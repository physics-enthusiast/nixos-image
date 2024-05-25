{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... }:
  let
    architectures = builtins.fromJSON (builtins.readFile ./architectures.json);
    configurations = builtins.map (filename: builtins.replaceStrings [".nix"] [""] filename) (builtins.attrNames (builtins.readDir ./configurations));
  in
  {
    packages = nixpkgs.lib.genAttrs architectures (architecture:
    let
      pkgs = import nixpkgs { system = "${architecture}-linux"; };
    in
    let
    stdenvs = rec {
      stdenv = pkgs.stdenv;
      final = stdenv.__bootPackages.stdenv;
      stage4 = final.__bootPackages.stdenv;
      stage3 = stage4.__bootPackages.stdenv;
      stage2 = stage3.__bootPackages.stdenv;
      stage1 = stage2.__bootPackages.stdenv;
    };
    toCache = stage: pkgs.mkBinaryCache { 
      rootPaths = [stage]; 
    };
    in
    nixpkgs.lib.mapAttrs (name: value: toCache value) stdenvs );
    nixosModules.customFormats = {config, lib, ...}: {
      formatConfigs.amazon = {config, lib, ...}: {
        amazonImage.sizeMB = "auto";
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
    nixosConfigurations = builtins.listToAttrs (nixpkgs.lib.lists.forEach (nixpkgs.lib.attrsets.cartesianProductOfSets { architecture = architectures; configuration = configurations; }) (systemInfo: nixpkgs.lib.attrsets.nameValuePair "nixos-${systemInfo.configuration}-${systemInfo.architecture}" (nixpkgs.lib.nixosSystem {
      system = "${systemInfo.architecture}-linux";
      modules = [
        nixos-generators.nixosModules.all-formats
        self.nixosModules.customFormats
        (nixpkgs.lib.path.append ./configurations "${systemInfo.configuration}.nix")
      ];
    })));
  };
}
