{ self, inputs, ... }:
let
  hostName = "FAGGOTTRON3000";

  myMachine = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      self.nixosModules.preferences
      self.nixosModules.persistance
      self.nixosModules.diskLayout
      self.nixosModules.gamesStorage
      self.nixosModules.impermanence
      self.nixosModules.myMachineHardware
      self.nixosModules.myMachineFeatures
      self.nixosModules.myMachineConfiguration
    ];
  };
in {
  flake.hostName = hostName;

  flake.nixosConfigurations = {
    myMachine = myMachine;
    ${hostName} = myMachine;
  };
}
