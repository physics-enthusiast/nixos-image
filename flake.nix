{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }: let
  architectures = builtins.fromJSON (builtins.readFile ./architectures.json);
  configurations = builtins.map (filename: builtins.replaceStrings [".nix"] [""] filename) (builtins.attrNames (builtins.readDir ./configurations));
  in
  {
    nixosModules.formatFixes = {config, lib, ...}: {
      image.modules =
        qemu = {
          services.qemuGuest.enable = true;
        };
    }; 
    nixosConfigurations = builtins.listToAttrs (nixpkgs.lib.lists.forEach (nixpkgs.lib.attrsets.cartesianProduct { architecture = architectures; configuration = configurations; }) (systemInfo: nixpkgs.lib.attrsets.nameValuePair "nixos-${systemInfo.configuration}-${systemInfo.architecture}" (nixpkgs.lib.nixosSystem {
      system = "${systemInfo.architecture}-linux";
      modules = [
        self.nixosModules.formatFixes
        (nixpkgs.lib.path.append ./configurations "${systemInfo.configuration}.nix")
      ];
    })));
  };
}
