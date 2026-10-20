{ self, inputs, ... }: {
  flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      self.nixosModules.preferences
      self.nixosModules.persistance
      self.nixosModules.diskLayout
      self.nixosModules.gamesStorage
      self.nixosModules.impermanence
      self.nixosModules.myMachineConfiguration
    ];
  };
}
