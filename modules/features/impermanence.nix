{ ... }: {
  flake.nixosModules.impermanence = {
    boot.initrd.systemd.enable = true;

    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        directories = [
          "/etc/ssh"
          "/var/lib/bluetooth"
          "/var/lib/NetworkManager"
          { directory = "/var/lib/nixos"; inInitrd = true; }
        ];
        files = [
          { file = "/etc/machine-id"; inInitrd = true; }
        ];
      };
    };

    persistance.data.directories = [
      ".ssh"
      ".gnupg"
      "mynixos"
      "Downloads"
      ".local/share/keyrings"
    ];
  };
}
