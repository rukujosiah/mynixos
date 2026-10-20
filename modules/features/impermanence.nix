{
  flake.nixosModules.impermanence = {
    boot.initrd.systemd.enable = true;
    preservation.enable        = true;

    systemd.services."systemd-machine-id-commit".enable = false;

    persistance = {
      system.directories = [
        { directory = "/var/lib/nixos"; inInitrd = true; }
      ];
      system.files = [
        { file = "/etc/machine-id"; inInitrd = true; }
      ];
      data.directories = [
        ".gnupg"
        "mynixos"
        "Downloads"
        ".local/share/keyrings"
      ];
    };
  };
}
