{ ... }: {
  flake.nixosModules.samba = { pkgs, ... }: {
    services.gvfs.enable = true;

    # cifs-utils provides mount.cifs for persistent/manual mounts
    environment.systemPackages = [ pkgs.cifs-utils ];

    # preserve gvfs bookmarks and smb credentials cache
    persistance.data.directories = [ ".local/share/gvfs-metadata" ];
  };
}
