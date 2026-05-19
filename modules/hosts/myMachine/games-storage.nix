{ ... }: {
  flake.nixosModules.gamesStorage = { ... }: {
    fileSystems."/games" = {
      device  = "/dev/disk/by-uuid/eec04d4d-b8d6-4a04-945e-1ab4951cdd55";
      fsType  = "ext4";
      options = [ "defaults" "nofail" ];
    };

    systemd.tmpfiles.rules = [
      "d /games            0755 nixruuku nixruuku -"
      "d /games/Steam      0755 nixruuku nixruuku -"
      "d /games/Lutris     0755 nixruuku nixruuku -"
      "d /games/prefixes   0755 nixruuku nixruuku -"
    ];
  };
}
