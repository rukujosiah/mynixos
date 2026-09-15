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

        users.nixruuku = {
          directories = [
            ".ssh"
            ".gnupg"
            "mynixos"
            "Downloads"
            ".config/chromium"
            ".mozilla"
            ".local/share/TelegramDesktop"
            ".local/share/Steam"
            ".local/share/keyrings"
          ];
        };
      };
    };
  };
}
