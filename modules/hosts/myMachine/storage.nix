{ ... }: {
  flake.nixosModules.gamesStorage = {
    fileSystems."/games" = {
      device  = "/dev/disk/by-uuid/1201422c-76a7-424d-afb2-d472370e40ff";
      fsType  = "ext4";
      options = [ "nofail" "x-systemd.device-timeout=5" ];
    };
  };
}
