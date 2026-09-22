{ ... }: {
  flake.nixosModules.vesktop = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vesktop ];

    persistance.cache.directories = [ ".config/vesktop" ];
  };
}
