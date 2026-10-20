{
  flake.nixosModules.samba = { pkgs, ... }: {
    services.gvfs.enable = true;

    environment.systemPackages = [ pkgs.cifs-utils ]; # provides mount.cifs for persistent/manual mounts

    persistance.data.directories = [ ".local/share/gvfs-metadata" ]; # gvfs bookmarks and smb credentials cache preservation
  };
}
