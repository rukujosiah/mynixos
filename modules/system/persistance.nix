{ ... }: {
  flake.nixosModules.persistance = { lib, config, ... }: {
    options.persistance = {
      # user data — keys, repos, documents
      data.directories = lib.mkOption {
        type    = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
        default = [];
      };
      # regeneratable state — caches, tool databases, app state
      # dedicated cache subvolume can be wired in disko.nix later
      cache.directories = lib.mkOption {
        type    = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
        default = [];
      };
    };

    config.preservation.preserveAt."/persistent".users.nixruuku.directories =
      config.persistance.data.directories ++
      config.persistance.cache.directories;
  };
}
